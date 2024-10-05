{ inputs, ... }: {
  _all.nixos = {
    imports = [ inputs.nix-index-database.nixosModules.nix-index ];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    nixpkgs.config.permittedInsecurePackages = [
      "freeimage-unstable-2021-11-01"
    ];
    nixpkgs.overlays = [
      (final: prev: {
        intel-vaapi-driver = prev.intel-vaapi-driver.override { enableHybridCodec = true; };
        staruml = final.callPackage ./staruml.nix {};
#         rofi-wayland-unwrapped = prev.rofi-wayland-unwrapped.overrideAttrs({ patches ? [], ... }: {
#           patches = patches ++ [
#             (final.fetchpatch {
#               url = "https://github.com/samueldr/rofi/commit/55425f72ff913eb72f5ba5f5d422b905d87577d0.patch";
#               hash = "sha256-vTUxtJs4SuyPk0PgnGlDIe/GVm/w1qZirEhKdBp4bHI=";
#             })
#           ];
#         });
      })
    ];
  };
}
