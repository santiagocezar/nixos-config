{
  description = "Eggfleet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, ... }@inputs: {
    nixosConfigurations =
      let
        eachHost = hosts: f:
          builtins.listToAttrs (
            builtins.map (
              host: {
                name = host;
                value = nixpkgs.lib.nixosSystem (f host);
              }
            ) hosts
          );
      in
        eachHost ["e102" "e123"] (host: {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./hardware/${host}.nix
            ./hosts/${host}.nix
            ./common

            ({ pkgs, lib, ... }: {
              networking.hostName = host;
            })
          ];
        });
  };
}
