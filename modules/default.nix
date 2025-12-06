{ pkgs, sources }:

let
  inherit (sources) nixpkgs;
  eval = import "${nixpkgs}/nixos/lib/eval-config.nix";
  home-manager = import sources.home-manager { inherit pkgs; };
  merge = import ../utils/merge.nix pkgs.lib;
  merged = merge.fromDirectory ./. { inherit pkgs sources; };
in
  {
    nixos = builtins.mapAttrs (host: cfg:
      eval {
        system = builtins.currentSystem;
        modules = cfg.nixos ++ [
          {
            networking.hostName = host;
            system.stateVersion = "23.11";
          }
        ];
      }
    ) merged;

    # yes, this is using hostnames instead of usernames
    home = builtins.mapAttrs (host: config:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {};
        modules = config.home ++ [
          {
            home.username = "santi";
            home.homeDirectory = "/home/santi";
            home.stateVersion = "23.11";
          }
        ];
      }
    ) merged;
  }
