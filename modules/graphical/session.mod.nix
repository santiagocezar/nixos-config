{
  _pc.nixos =
    { pkgs, ... }:
    {
      # Enable the X11 windowing system.
      services.xserver.enable = true;

      # temp workaround https://github.com/NixOS/nixpkgs/issues/357152
      environment.variables.MESA_DISK_CACHE_MULTI_FILE = "1";
      services.xserver.displayManager.importedVariables = [ "MESA_DISK_CACHE_MULTI_FILE" ];

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
          kdePackages.xdg-desktop-portal-kde
        ];
      };

      environment.systemPackages = with pkgs; [
        gnupg
        # gnome.seahorse
        kdePackages.ktexteditor # This adds PolKit support to kate? [^1]
      ];

      programs.gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.lib.mkForce pkgs.pinentry-qt;
        enableSSHSupport = true;
      };

      # Enable sound with pipewire.

      services.pulseaudio.enable = false;

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
          noto-fonts-color-emoji
          noto-fonts-cjk-sans
        ];
      };

      # Enable GTK theming for Wayland apps on KDE
      programs.dconf.enable = true;

      security.polkit.enable = true;

      # Use GNOME keyring on Niri
      # services.gnome.gnome-keyring.enable = true;
      # security.pam.services.sddm.enableGnomeKeyring = true;
    };
}

/*
  References:
  ^1: https://discourse.nixos.org/t/edit-configuration-nix-using-kate/37218/2
*/
