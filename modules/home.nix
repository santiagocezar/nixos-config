{ home-manager, ... }: {
  _pc.nixos = { config, pkgs, ... }: {
    imports = [ home-manager.nixosModules.home-manager ];
    home-manager = {
      # extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
      useUserPackages = true;
      users.santi = {
        home.username = "santi";
        home.homeDirectory = "/home/santi";

        # Backwards compatibility safety!
        home.stateVersion = "23.11";
        imports = config._module.args.home_modules;
      };
    };
  };

  _all.nixos = { pkgs, ... }: {
    users.users.santi = {
      isNormalUser = true;
      description = "Santi";
      extraGroups = [ "networkmanager" "dialout" "wheel" "libvirtd" "aria2" ];
      initialPassword = "cambiar";
      shell = pkgs.fish;
    };
  };

  e123.nixos = { pkgs, ... }: {
    users.users.flor = {
      isNormalUser = true;
      description = "Flor";
      extraGroups = [ "networkmanager" ];
      shell = pkgs.fish;
    };
  };

  _pc.home = { config, pkgs, ... }: {
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
      # "${config.home.homeDirectory}/.XCompose".source = ./xcompose.txt;
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
  };
}
