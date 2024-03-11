{ config, pkgs, inputs,  ... }:
let
  user = "santi";
  home = "/home/${user}";

  system = pkgs.system;
  vsc-extensions = inputs.nix-vscode-extensions.extensions.${system};
  fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    dejavu_fonts
    fira-code
  ];

  yup = pkgs.writeShellScriptBin "yup" ''
    # Commit and update the system
    set -uex
    cd ~/NixOS/
    git diff -u
    sudo nixos-rebuild switch --flake path:.
    git add .
    git commit -m "$1"
  '';
in
  {
    home.username = user;
    home.homeDirectory = home;

    # Backwards compatibility safety!
    home.stateVersion = "23.11";

    home.packages = with pkgs; [
      # Apps
      filezilla
      firefox
      fractal
      furnace
      google-chrome
      kdePackages.kate
      libqalculate
      libreoffice
      kdePackages.neochat
      nheko
      obsidian
      octaveFull
      qalculate-qt
      qbittorrent
      steam
      steam-run
      thunderbird
      vlc
      vnote
      wineWowPackages.waylandFull
      xournalpp

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
        vscodeExtensions = with vsc-extensions.vscode-marketplace; [
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
      cachix
      evtest
      file
      gparted
      htop
      jq
      mediawriter
      micro
      ncdu
      neofetch
      nix-index
      p7zip
      unrar
      usbutils
      ventoy
      xorg.xeyes
      yup
    ] ++ fonts;

    services.syncthing.enable = true;

    fonts.fontconfig.enable = true;

    # Add SDL2_gfx to the uh, sandbox? used by `steam-run`
    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          SDL2_gfx
        ] ++ fonts;
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
        function fish_user_key_bindings
          bind \e\[3\;5~ kill-word
          bind \b backward-kill-word
          #bind \cC strike_cancel
        end
      '';
      shellAliases = {
      };
    };
    programs.starship.enable = true;
    programs.zoxide.enable = true;

    programs.home-manager.enable = true;
  }
