{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./cachix.nix
      ./containers.nix
      ./session.nix
      ./network.nix
      ./apps.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "v4l2loopback" ];

  boot = {
    plymouth.enable = true;
    plymouth.theme = "bgrt";
    initrd.systemd.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    santi = {
      isNormalUser = true;
      description = "Santi";
      extraGroups = [ "networkmanager" "dialout" "wheel" "libvirtd" ];
      shell = pkgs.fish;
    };
    flor = {
      isNormalUser = true;
      description = "Flor";
      extraGroups = [ "networkmanager" ];
      shell = pkgs.fish;
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.santi = import ./home.nix;
  };

  time.timeZone = "America/Argentina/Cordoba";

  i18n.defaultLocale = "es_ES.UTF-8";
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

  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  nix = {
    settings = {
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-public-keys = [ "e123:yqa6CRpymC7WLiD5pHVrEyqvhXQLSbxl4bOAdlA8/eY=" ];
    };

    # https://dataswamp.org/~solene/2022-07-20-nixos-flakes-command-sync-with-system.html
    registry.nixpkgs.flake = inputs.nixpkgs;


    # nvm do bog the pc
    # daemonCPUSchedPolicy = pkgs.lib.mkDefault "idle";
    # daemonIOSchedClass = pkgs.lib.mkDefault "idle";
    # daemonIOSchedPriority = pkgs.lib.mkDefault 7;

  };
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01"
  ];
}
