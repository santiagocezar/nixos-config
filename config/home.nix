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
      kate
      libqalculate
      libreoffice
      libsForQt5.ktexteditor.bin # This adds PolKit support to kate [^1]
      nheko
      octaveFull
      qalculate-qt
      qbittorrent
      steam
      steam-run
      vlc
      vnote
      wineWowPackages.waylandFull
      xournalpp
      (mathematica.override {
        source = pkgs.requireFile {
          name = "Mathematica_13.3.1_LINUX.sh";
          sha256 = "sha256:0w7v31pwj2ax9886b6c6r58gz642j7a1ashgv2nl0dzpq1dj7x6v";
          message = ''
            Your override for Mathematica includes a different src for the installer,
            and it is missing.
          '';
          hashMode = "recursive";
        };
      })

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

/*
References:
^1: https://discourse.nixos.org/t/edit-configuration-nix-using-kate/37218/2
*/