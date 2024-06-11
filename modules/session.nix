{
  _pc.nixos = { pkgs, ... }: {

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "latam";
      variant = "";
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-kde
      ];
    };


    environment.systemPackages = with pkgs; [
      gnupg
      gnome.seahorse
      kdePackages.ktexteditor # This adds PolKit support to kate? [^1]
    ];

    programs.gnupg.agent  = {
      enable = true;
      pinentryPackage = pkgs.lib.mkForce pkgs.pinentry-qt;
      enableSSHSupport = true;
    };

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk
      ];
    };

    # Enable GTK theming for Wayland apps on KDE
    programs.dconf.enable = true;

    security.polkit.enable = true;

    # Use GNOME keyring on Niri
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}

/*
References:
^1: https://discourse.nixos.org/t/edit-configuration-nix-using-kate/37218/2
*/

