{ inputs }:

let
  inherit (inputs) nixpkgs home-manager;
  merge = import ../utils/merge.nix nixpkgs.lib;
  merged = merge.fromDirectory ./. inputs;
in
  {
    nixosConfigurations = builtins.mapAttrs (host: config:
      nixpkgs.lib.nixosSystem {
        system = config.system;
        specialArgs = {
          smallPkgs = import inputs.nixpkgs-small {
            inherit (config) system;
            config.allowUnfree = true;
          };
        };
        modules = config.nixos ++ [
          {
            networking.hostName = host;
            system.stateVersion = "23.11";
          }
        ];
      }
    ) merged;

    # yes, this is using hostnames instead of usernames
    homeConfigurations = builtins.mapAttrs (host: config:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${config.system};
        modules = config.home ++ [
          {
            # i guess these two have to be hardcoded
            home.username = "santi";
            home.homeDirectory = "/home/santi";
            home.stateVersion = "23.11";
          }
        ];
      }
    ) merged;
  }
