{ ... }:
{
  _all.nixos = {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    nixpkgs.config.permittedInsecurePackages = [
      "freeimage-unstable-2021-11-01"
    ];
    nixpkgs.overlays = [
      (final: prev: {
        # obs-studio = prev.wrapOBS {
        #   plugins = with prev.obs-studio-plugins; [
        #     obs-vaapi
        #   ];
        # };
        # Add SDL2_gfx to the uh, sandbox? used by `steam-run`
        intel-vaapi-driver = prev.intel-vaapi-driver.override { enableHybridCodec = true; };
        staruml = final.callPackage ./staruml.nix { };
      })
    ];
  };
}
