{ nixpkgs, home-manager, ... }@inputs: hosts:

builtins.mapAttrs (
  host: info:
    nixpkgs.lib.nixosSystem {
      inherit (info) system;
      specialArgs = { inherit inputs; };
      modules = [
        home-manager.nixosModules.home-manager
        ./${host}.nix
        ./${host}_hardware.nix
        ../common

        ({ pkgs, lib, ... }: {
          networking.hostName = host;
        })
      ];
    }
) hosts
