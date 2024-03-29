{ config, pkgs, inputs,  ... }:
let
  user = "santi";
  home = "/home/${user}";

  fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    dejavu_fonts
    fira-code
  ];
in
  {
    home.username = user;
    home.homeDirectory = home;

    # Backwards compatibility safety!
    home.stateVersion = "23.11";

    home.packages = fonts;

    fonts.fontconfig.enable = true;

    # Manually source 'hm-session-vars.sh' located at
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #  /etc/profiles/per-user/santi/etc/profile.d/hm-session-vars.sh
    home.sessionVariables = {
      EDITOR = "kwrite";
      PNPM_HOME = "/home/santi/.local/share/pnpm";
    };
    home.sessionPath = [
      "$HOME/.local/bin"
      "$PNPM_HOME"
    ];

    home.file = {
#       "${config.home.homeDirectory}/.XCompose".source = ./xcompose.txt;
      "${config.xdg.configHome}/plasma-workspace/env/hm.sh".text = ''
        source ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh
      '';
    };

    programs.fish = {
      enable = true;
      shellInit = ''
        function fish_user_key_bindings
          bind \e\[3\;5~ kill-word
          bind \b backward-kill-word
          #bind \cC strike_cancel
        end
      '';
      shellAliases = {
        j = "just";
      };
    };
    programs.starship.enable = true;
    programs.zoxide.enable = true;
    programs.direnv.enable = true;

    programs.home-manager.enable = true;
    services.syncthing.enable = true;
  }
