{
  description = "Eggfleet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, ... }@inputs:
    let
      config = (import ./modules) {
        inherit inputs;
      };
    in
      {
        inherit (config) homeConfigurations nixosConfigurations;
        packages.x86_64-linux = with nixpkgs.legacyPackages.x86_64-linux; {
          yup = writeShellApplication {
            name = "yup";
            runtimeInputs = [ git ];
            text = builtins.readFile resources/yup.sh;
            runtimeEnv.SRC = self;
          };
          default = self.packages.x86_64-linux.yup;
        };
      };
}
