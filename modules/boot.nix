{ lanzaboote, ... }: {
  _all.nixos = {
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      initrd.systemd.enable = true;
    };
  };
  _pc.nixos = {
    boot = {
      plymouth.enable = true;
      plymouth.theme = "bgrt";
    };
  };

  e123.nixos = { pkgs, lib, ... }: {
    imports = [ lanzaboote.nixosModules.lanzaboote ];

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];
  };
}
