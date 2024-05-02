{ config, pkgs, inputs, ... }:

let
  yup = pkgs.writeScriptBin "yup" (builtins.readFile ./../yup.sh);
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
      rnote
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
      vscode.fhs

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
    ];

    programs.steam.enable = true;
    programs.direnv.enable = true;
    hardware.opengl.driSupport32Bit = true;
  }
