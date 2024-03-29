{ config, pkgs, inputs, ... }:

let
  system = pkgs.system;
  yup = pkgs.writeShellScriptBin "yup" ''
    # Commit and update the system
    set -uex
    cd ~/NixOS/
    git diff -u
    git add .
    git pull --rebase
    sudo nixos-rebuild switch --flake path:.
    git commit -m "$1"
    git push
  '';
  fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    dejavu_fonts
    fira-code
  ];
  vsc-extensions = inputs.nix-vscode-extensions.extensions.${system};
  vscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with vsc-extensions.vscode-marketplace; [
      ms-python.python
      ms-vscode-remote.remote-ssh
    ];
  };
  retroarch = pkgs.retroarch.override {
    cores = with pkgs.libretro; [
      genesis-plus-gx
      snes9x
      beetle-psx-hw
    ];
  };
in
  {
    environment.systemPackages = with pkgs; [
      # Apps
      dolphin-emu
      drawio
      filezilla
      firefox
      fractal
      furnace
      gimp
      google-chrome
      inkscape
      kdePackages.kate
      kdePackages.neochat
      krita
      libqalculate
      libreoffice
      logseq
      nheko
      obsidian
      obs-studio
      octaveFull
      qalculate-qt
      qbittorrent
      scrcpy
      thunderbird
      vesktop
      vlc
      vnote
      wineWowPackages.waylandFull
      xournalpp

      # Development
      arduino-ide
      clang
      clang-tools
      flatpak-builder
      gh
      git
      godot_4
      just
      nixpkgs-fmt
      nodePackages.pnpm
      nodejs
      poetry
      ps2client
      python3
      vscode

      # Games
      gamescope
      gzdoom
      mangohud
      osu-lazer-bin
      prismlauncher
      retroarch
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
    programs.direnv.enable = true;
    hardware.opengl.driSupport32Bit = true;
  }
