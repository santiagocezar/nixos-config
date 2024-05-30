{
  _all.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git
      cachix
      file
      htop
      jq
      micro
      ncdu
      neofetch
      nix-index
      p7zip
      usbutils
      unrar
      (writeScriptBin "yup" (builtins.readFile ./../yup.sh))
    ];
  };
  _pc.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Apps
      dolphin-emu
      drawio
      filezilla
      firefox
      gimp
      google-chrome
      inkscape
      kdePackages.kate
      kdePackages.neochat
      krita
      libqalculate
      libreoffice
      obsidian
      obs-studio
      octaveFull
      qalculate-qt
      qbittorrent
      rnote
      scrcpy
      staruml
      thunderbird
      vesktop
      vlc
      xournalpp

      # Development
      clang
      clang-tools
      flatpak-builder
      gh
      godot_4
      just
      nixpkgs-fmt
      nodePackages.pnpm
      nodejs
      poetry
      python3
      vscode.fhs

      # Games
      gamescope
      gzdoom
      mangohud
      osu-lazer-bin
      prismlauncher
      srb2
      srb2kart

      # Utilities
      evtest
      gparted
      mediawriter
      ventoy
      wl-clipboard
      xorg.xeyes
    ];

    programs.steam.enable = true;
    programs.direnv.enable = true;
    programs.fish.enable = true;
    programs.nix-ld.enable = true;
    programs.kdeconnect.enable = true;
    hardware.opengl.driSupport32Bit = true;
  };
}
