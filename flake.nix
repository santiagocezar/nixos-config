{
  description = "Eggfleet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, ... }@inputs:
    let
      mergeModules = import ./mergeModules.nix;
      modules = import ./modules;
      withISO = import ./withISO.nix;
      configs = mergeModules inputs modules {
        all = ["e102" "e123" "e1001"];
        pc = ["e102" "e123"];
        srv = ["e1001"];
      };
    in
      {
        nixosConfigurations =
          withISO configs;
      };
}
