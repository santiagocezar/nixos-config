# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
      ./containers.nix
      ./session.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.santi = {
    isNormalUser = true;
    description = "Santi";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    shell = pkgs.fish;
  };

  home-manager = {
    # Optionally, use home-manager.extraSpecialArgs to pass
    # arguments to home.nix
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.santi = import ./home.nix;
  };

  time.timeZone = "America/Argentina/Cordoba";

  i18n.defaultLocale = "es_MX.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Enable GTK theming for Wayland apps on KDE
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  # Share PS2 games with OPL
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      dns proxy = no
      log file = /var/log/samba/%m.log
      max log size = 1000
      server min protocol = CORE
      client min protocol = CORE
      client max protocol = SMB3

      map to guest = Bad User
      usershare allow guests = yes
      name resolve order = lmhosts bcast host wins
      security = user
      guest account = nobody
    '';
    shares = {
      ps2 = {
        "comment" = "ps2";
        "path" = "/var/ps2";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "public" = "yes";
        "available" = "yes";
      };
    };
  };


  networking.hostName = "e102";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [
    8010 # VLC
  ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # https://dataswamp.org/~solene/2022-07-20-nixos-flakes-command-sync-with-system.html
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01"
  ];
}
