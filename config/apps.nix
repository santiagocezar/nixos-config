{ config, pkgs, inputs, ... }:

let
  system = pkgs.system;
  vsc-extensions = inputs.nix-vscode-extensions.extensions.${system};
  yup = pkgs.writeShellScriptBin "yup" ''
    # Commit and update the system
    set -uex
    cd ~/NixOS/
    git diff -u
    sudo nixos-rebuild switch --flake path:.
    git add .
    git commit -m "$1"
  '';
  fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    dejavu_fonts
    fira-code
  ];
in
  {
    environment.systemPackages = with pkgs; [
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

    # Add SDL2_gfx to the uh, sandbox? used by `steam-run`
    programs.steam.package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        SDL2_gfx
      ] ++ fonts;
    };
    programs.steam.enable = true;
  }
