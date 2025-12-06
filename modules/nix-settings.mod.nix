{ sources, ... }: {
  _all.nixos = { pkgs, ... }: {
    # https://jade.fyi/blog/pinning-nixos-with-npins/
    nixpkgs.flake.source = sources.nixpkgs;

    nix = {
      package = pkgs.lix;
      settings = {
        # Enable flakes
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        trusted-public-keys = [ "e123:yqa6CRpymC7WLiD5pHVrEyqvhXQLSbxl4bOAdlA8/eY=" ];
      };

      registry.nixpkgs.to = {
        type = "path";
        path = sources.nixpkgs;
      };
    };
  };
}
