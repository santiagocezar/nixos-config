{ config, pkgs, inputs, ... }:
{
  home.username = "santi";
  home.homeDirectory = "/home/santi";

  # Backwards compatibility safety!
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    # Apps
    firefox
    kate
    libreoffice
    libsForQt5.ktexteditor.bin # This adds PolKit support to kate (https://discourse.nixos.org/t/edit-configuration-nix-using-kate/37218/2)
    qbittorrent
    steam
    steam-run
    vlc
    vnote
    filezilla

    # Development
    clang
    clang-tools
    flatpak-builder
    git
    godot_4
    nixpkgs-fmt
    nodePackages.pnpm
    nodejs
    poetry
    ps2client
    python3
    rnix-lsp
    (vscode-with-extensions.override {
      vscodeExtensions = with inputs.vscode-ext.vscode-marketplace; [
        ms-python.python
        ms-vscode-remote.remote-ssh
      ];
    })

    # Games
    gzdoom
    srb2
    srb2kart
    trenchbroom

    # Utilities
    evtest
    file
    htop
    jq
    micro
    ncdu
    neofetch
    nix-index
    p7zip
    unrar
    xorg.xeyes

    # Fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    dejavu_fonts
  ];

  services.syncthing.enable = true;

  fonts.fontconfig.enable = true;

  # Add SDL2_gfx to the uh, sandbox? used by `steam-run`
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        SDL2_gfx

        # used by Sven Co-op
        noto-fonts
        dejavu_fonts
      ];
    };
  };

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
    "${config.xdg.configHome}/plasma-workspace/env/hm.sh".text = ''
      source ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh
    '';
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      set -gx PNPM_HOME
      if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
      end
      function yup -d "Commit and update the system"
        cd ~/NixOS/
        git add .
        git commit -m $argv[1]
        sudo nixos-rebuild switch --flake .
      end
    '';
    shellAliases = {
    };
  };
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  programs.home-manager.enable = true;
}
