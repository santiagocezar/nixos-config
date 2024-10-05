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
        # obs-studio = prev.wrapOBS {
        #   plugins = with prev.obs-studio-plugins; [
        #     obs-vaapi
        #   ];
        # };
        # Add SDL2_gfx to the uh, sandbox? used by `steam-run`
        intel-vaapi-driver = prev.intel-vaapi-driver.override { enableHybridCodec = true; };
        staruml = final.callPackage ./staruml.nix {};
        rofi-wayland-unwrapped = prev.rofi-wayland-unwrapped.overrideAttrs({ patches ? [], ... }: {
          patches = patches ++ [
            (final.fetchpatch {
              url = "https://github.com/samueldr/rofi/commit/55425f72ff913eb72f5ba5f5d422b905d87577d0.patch";
              hash = "sha256-vTUxtJs4SuyPk0PgnGlDIe/GVm/w1qZirEhKdBp4bHI=";
            })
          ];
        });

        /* prev.staruml.overrideAttrs (oldAttrs: {
          nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
            final.asar
          ];
          postFixup = (oldAttrs.postFixup or "") + ''
            asar extract $out/opt/StarUML/resources/app.asar app
            patch -d app/ -p1 < ${../resources/patches/staruml-stupid-evaluation-mode-remover-3000.patch}
            asar pack app $out/opt/StarUML/resources/app.asar
          '';
        }); */
        # kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
        #   kservice = kprev.kservice.overrideAttrs {
        #     patches = [./canonical.patch];
        #   };
        # });
      })
    ];
  };
}
