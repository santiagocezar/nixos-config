{
  _pc.nixos = [
    ({ pkgs, ... }: {
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
    })
  ];

  e123.nixos = [
    (import ./generated/e123_hardware.nix)
    ({ config, pkgs, ... }: {
      boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
      boot.kernelModules = [ "i2c-dev" "ddcci_backlight" "v4l2loopback" ];

      nixpkgs.config.packageOverrides = pkgs: {
        intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
      };
      hardware.opengl = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver # LIBVA_DRIVER_NAME=iHD
          intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
          libvdpau-va-gl
        ];
      };
      environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

      hardware.opentabletdriver.enable = true;
    })
  ];
  e102.nixos = [
    (import ./generated/e102_hardware.nix)
    {
      # Turn media keys into text cursor movement keys
      services.udev.extraHwdb = ''
        evdev:input:b0011v0001p0001*
         KEYBOARD_KEY_90=home
         KEYBOARD_KEY_a2=pageup
         KEYBOARD_KEY_a4=pagedown
         KEYBOARD_KEY_99=end
      '';
    }
  ];

  e123.system = "x86_x64-linux";
  e102.system = "x86_x64-linux";
  e1001.system = "x86_x64-linux";
}
