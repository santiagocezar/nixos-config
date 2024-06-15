{
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
      sops
      unrar
      usbutils
      (writeScriptBin "yup" (builtins.readFile ./../yup.sh))
    ];
    programs.fish.enable = true;
  };
  _pc.nixos = { pkgs, smallPkgs, ... }: {
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
      kdePackages.kdenlive
      kdePackages.neochat
      krita
      libqalculate
      libreoffice
      smallPkgs.obsidian # TODO: remove after build works again
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

    programs.steam.enable = true;
    programs.direnv.enable = true;
    programs.nix-ld.enable = true;
    programs.kdeconnect.enable = true;
    hardware.opengl.driSupport32Bit = true;
  };
}
