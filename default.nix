let
  sources = import ./lon.nix;
  pkgs = import sources.nixpkgs {};
in
  (import ./modules) {
    inherit pkgs sources;
  }
