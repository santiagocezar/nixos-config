{
  _pc.nixos = { pkgs, ... }: {
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
    hardware.sane.enable = true;

    # Enable CUPS
    services.printing.enable = true;
    services.printing.drivers = [
        pkgs.epson-escpr
    ];

    services.pcscd.enable = true; # what the heck is a smartcard
  };

  e123.nixos = { config, pkgs, oldPkgs, ... }: {
    imports = [ ./gen/e123_hardware.nix ];

    boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    boot.kernelModules = [ "i2c-dev" "ddcci_backlight" "v4l2loopback" ];
    hardware.graphics = {
      enable = true;
      package = oldPkgs.mesa.drivers;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];
    };
    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
    hardware.opentabletdriver.enable = true;
  };
  e102.nixos = {
    imports = [ ./gen/e102_hardware.nix ];

	services.power-profiles-daemon.enable = false;
	services.tlp.enable = true;

    # Turn media keys into text cursor movement keys
    services.udev.extraHwdb = ''
      evdev:input:b0011v0001p0001*
       KEYBOARD_KEY_90=home
       KEYBOARD_KEY_a2=pageup
       KEYBOARD_KEY_a4=pagedown
       KEYBOARD_KEY_99=end
    '';
  };
  e1001.nixos = { pkgs, ... }: {
    imports = [ ./gen/e1001_hardware.nix ];
    boot.extraModprobeConfig = ''
      options rtl8723be ips=0 fwlps=0 # stable wifi hopefully
    '';
    services.logind.lidSwitch = "ignore";
    # enableHybridCodec override in nixpkgs.nix
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver # previously vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
        intel-media-sdk # QSV up to 11th gen
      ];
    };
  };

  e123.system = "x86_64-linux";
  e102.system = "x86_64-linux";
  e1001.system = "x86_64-linux";
}
