{ ... }:
{
  _all.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        cachix
        file
        git
        htop
        jq
        lon
        # micro
        ncdu
        neofetch
        nh
        nix-output-monitor
        p7zip
        ripgrep
        sops
        unrar
        usbutils
      ];
    };
  _pc.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        libqalculate
        qalculate-qt
        scrcpy
        thunderbird
        vlc
        syncthingtray

        # Development
        flatpak-builder
        gh
        ghostty
        just
        bun
        nil
        nodejs
        poetry
        python3
        zed-editor
        # vscode.fhs

        # Games
        gamescope
        mangohud

        # Utilities
        evtest
        kdePackages.partitionmanager
        mediawriter
        wl-clipboard
        xorg.xeyes
      ];

      programs.firefox.enable = true;
      programs.steam.enable = true;
      programs.direnv.enable = true;
      programs.nix-ld.enable = true;
      programs.kdeconnect.enable = true;
      hardware.graphics.enable32Bit = true;
      # services.onedrive.enable = true;
    };
  _pc.home = {
    services.syncthing.enable = true;
  };
}
