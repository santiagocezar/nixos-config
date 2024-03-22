{ config, pkgs, inputs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
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

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
      pkgs.epson-escpr
  ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.input = {
    # re-enables support for the dualshock 3
    General = {
      ClassicBondedOnly = false;
    };
  };

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  services.pcscd.enable = true; # what the heck is a smartcard

  environment.systemPackages = with pkgs; [
    gnupg
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

  # Do it here instead of HM to automatically open ports I think
  programs.kdeconnect.enable = true;
}
/*
References:
^1: https://discourse.nixos.org/t/edit-configuration-nix-using-kate/37218/2
*/

