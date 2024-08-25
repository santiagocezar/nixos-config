{ self, ... }: {
  _all.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      cachix
      file
      git
      htop
      jq
      micro
      ncdu
      neofetch
      nix-index
      p7zip
      ripgrep
      sops
      unrar
      usbutils
      self.packages.${pkgs.system}.yup
    ];
    programs.fish.enable = true;
  };
  _pc.nixos = { pkgs, smallPkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Apps
      bottles
      dolphin-emu
      drawio
      filezilla
      gimp
      google-chrome
      inkscape
      kdePackages.kate
      kdePackages.kdenlive
      kdePackages.neochat
      krita
      libqalculate
      libreoffice
      obsidian
      obs-studio
      octaveFull
      qalculate-qt
      qbittorrent
      scrcpy
      spotify
      staruml
      thunderbird
      vesktop
      vlc
      xournalpp

      # Development
      flatpak-builder
      gh
      godot_4
      just
      nodePackages.pnpm
      nodejs
      poetry
      pcsx2
      python3
      vscode.fhs

      # Games
      gamescope
      gzdoom
      mangohud
      osu-lazer-bin
      prismlauncher
      ringracers
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

    programs.firefox.enable = true;
    programs.steam.enable = true;
    programs.direnv.enable = true;
    programs.nix-ld.enable = true;
    programs.kdeconnect.enable = true;
    hardware.graphics.enable32Bit = true;
  };
}
