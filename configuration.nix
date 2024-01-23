# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "e102"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Argentina/Cordoba";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "latam";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # https://discourse.nixos.org/t/best-way-to-define-common-fhs-environment/25930
    (pkgs.buildFHSUserEnv (pkgs.appimageTools.defaultFhsEnvArgs // {
      name = "fhs";
      runScript = "fish";
    }))

    nix-index
    file
    micro
    git
    flatpak-builder
    kate
    libsForQt5.ktexteditor.bin # This adds PolKit support to kate (https://discourse.nixos.org/t/edit-configuration-nix-using-kate/37218/2)
    nixpkgs-fmt
    rnix-lsp
    vlc
  ];

  # Enable GTK theming for Wayland apps on KDE
  programs.dconf.enable = true;

  security.polkit.enable = true;
  services.flatpak.enable = true;
  # Do it here instead of HM to automatically open ports I think
  programs.kdeconnect.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  # Turn media keys into text cursor movement keys
  services.udev.extraHwdb = ''
    evdev:input:b0011v0001p0001*
     KEYBOARD_KEY_90=home
     KEYBOARD_KEY_a2=pageup
     KEYBOARD_KEY_a4=pagedown
     KEYBOARD_KEY_99=end
  '';

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      dns proxy = no
      log file = /var/log/samba/%m.log
      max log size = 1000
      server min protocol = CORE
      client min protocol = CORE
      client max protocol = SMB3
      server role = standalone server
      passdb backend = tdbsam
      obey pam restrictions = yes
      unix password sync = yes
      passwd program = /usr/bin/passwd %u
      passwd chat = *New*UNIX*password* %n\n *ReType*new*UNIX*password* %n\n *passwd:*all*authentication*tokens*updated*successfully*
      pam password change = yes
      map to guest = Bad User
      usershare allow guests = yes
      name resolve order = lmhosts bcast host wins
      security = user
      guest account = nobody
      usershare path = /var/lib/samba/usershare
      usershare max shares = 100
      usershare owner only = yes
      force create mode = 0070
      force directory mode = 0070
      keepalive = 0
      smb ports = 445
   '';
    /*extraConfig = ''
      client min protocol = CORE
      client max protocol = NT1
      server max protocol = SMB3
      server min protocol = CORE
      strict sync = no
      keepalive = 0
    '';*/
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.firewall.allowPing = true;
  services.samba.openFirewall = true;
  networking.firewall.allowedTCPPorts = [
    8010 # VLC
  ];

  /*
  services.syncthing = {
    enable = true;
    dataDir = config.users.users.santi.home;
    configDir = "${config.users.users.santi.home}/.config/syncthing";
    user = "santi";
    overrideFolders = false;
    overrideDevices = false;
  };
  */

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # https://dataswamp.org/~solene/2022-07-20-nixos-flakes-command-sync-with-system.html
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
