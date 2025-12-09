{ sources, ... }:
let
  lanzaboote = import sources.lanzaboote;
in
{
  _pc.nixos = {
    boot = {
      plymouth.enable = true;
    };
  };
  _all.nixos = {
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      initrd.systemd.enable = true;
    };
  };

  e123.nixos =
    { pkgs, lib, ... }:
    {
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

  adachix00.nixos =
    { pkgs, lib, ... }:
    {
      imports = [ lanzaboote.nixosModules.lanzaboote ];

      environment.systemPackages = [
        # For debugging and troubleshooting Secure Boot.
        pkgs.sbctl
      ];

      # Lanzaboote currently replaces the systemd-boot module.
      # This setting is usually set to true in configuration.nix
      # generated at installation time. So we force it to false
      # for now.
      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  adachix00.home =
    { pkgs, lib, ... }:
    let
      boot-to-windows = pkgs.writeShellApplication {
        name = "boot-to-windows";
        runtimeInputs = with pkgs; [
          efibootmgr
          gnugrep
        ];
        text = ''
          # Look up the boot number for Windows in the EFI records
          boot_number=$(efibootmgr | grep -Po "(?<=Boot)\S{4}(?=( |\* )Windows)")

          # Check that Windows EFI entry was found
          if [ -z "$boot_number" ]; then
              >&2 echo "Cannot find Windows boot in EFI, exiting"
              exit 1
          fi

          # Set next boot to be Windows and reboot the machine
          sudo efibootmgr -n "$boot_number" && reboot
        '';
      };
    in
    {
      xdg.desktopEntries.boot-to-windows = {
        name = "Reiniciar a Windows";
        genericName = "Windows";
        exec = ''sh -c "SHELL=/bin/sh pkexec ${boot-to-windows}/bin/boot-to-windows"'';
        terminal = false;
        icon = "preferences-system-network-share-windows";
        categories = [ "Utility" ];
      };
    };
}
