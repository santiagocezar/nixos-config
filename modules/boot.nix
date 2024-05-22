{ lanzaboote, ... }: {
  shared.nixos = [
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot = {
        plymouth.enable = true;
        plymouth.theme = "bgrt";
        initrd.systemd.enable = true;
      };
    }
  ];

  e123.nixos = [
    lanzaboote.nixosModules.lanzaboote
    ({pkgs, lib, ...}: {
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
    })
  ];
}
