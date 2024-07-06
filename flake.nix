{
  description = "Eggfleet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
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
      config = import ./mergeModules.nix {
        inherit inputs;

        from = ./modules;
        groups = {
          all = ["e102" "e123" "e1001"];
          pc = ["e102" "e123"];
          srv = ["e1001"];
        };
      };
    in
      {
        inherit (config) homeConfigurations nixosConfigurations;
        packages.x86_64-linux = with nixpkgs.legacyPackages.x86_64-linux; {
          yup = writeShellApplication {
            name = "yup";
            runtimeInputs = [ git ];
            text = builtins.readFile resources/yup.sh;
          };
          default = self.packages.x86_64-linux.yup;
        };
      };
}
