{ nixpkgs, ... }: {
  shared.nixos = [
    {
      nix = {
        settings = {
          # Enable flakes
          experimental-features = [ "nix-command" "flakes" ];
          auto-optimise-store = true;
          trusted-public-keys = [ "e123:yqa6CRpymC7WLiD5pHVrEyqvhXQLSbxl4bOAdlA8/eY=" ];
        };

        # https://dataswamp.org/~solene/2022-07-20-nixos-flakes-command-sync-with-system.html
        registry.nixpkgs.flake = nixpkgs;


        # nvm do bog the pc
        # daemonCPUSchedPolicy = pkgs.lib.mkDefault "idle";
        # daemonIOSchedClass = pkgs.lib.mkDefault "idle";
        # daemonIOSchedPriority = pkgs.lib.mkDefault 7;
      };
    }
  ];
}
