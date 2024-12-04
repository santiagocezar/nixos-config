{ inputs, ... }: {
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
      nix-output-monitor
      p7zip
      ripgrep
      sops
      unrar
      usbutils
      inputs.self.packages.${pkgs.system}.yup
    ];
    programs.fish.enable = true;
  };
  _pc.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Apps
      # arduino
      # bottles
      # dolphin-emu
      # drawio
      # filezilla
      # gimp
      # google-chrome
      # inkscape
      kdePackages.kate
      # kdePackages.kdenlive
      # krita
      libqalculate
      # libreoffice
      # obsidian
      # obs-studio
      # octaveFull
      qalculate-qt
      # qbittorrent
      scrcpy
      # spotify
      # staruml
      thunderbird
      # vesktop
      vlc
      # xournalpp

      # Development
      flatpak-builder
      gh
      # godot_4
      just
      nodePackages.pnpm
      nodejs
      poetry
      # pcsx2
      python3
      # vscode.fhs

      # Games
      gamescope
      # gzdoom
      mangohud
      # osu-lazer-bin
      # prismlauncher
      # ringracers
      # srb2
      # srb2kart

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
    services.onedrive.enable = true;
  };
  _pc.home = {
    services.syncthing.enable = true;
  };
}
