{
  shared.nixos = [
    {
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
          steam = prev.steam.override {
            extraPkgs = pkgs: with pkgs; [
              SDL2_gfx
              noto-fonts
              noto-fonts-cjk
              noto-fonts-emoji
              dejavu_fonts
            ];
          };
          staruml = prev.staruml.overrideAttrs (oldAttrs: {
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
              final.asar
            ];
            postFixup = (oldAttrs.postFixup or "") + ''
              asar extract $out/opt/StarUML/resources/app.asar app
              patch -d app/ -p1 < ${./staruml-stupid-evaluation-mode-remover-3000.patch}
              asar pack app $out/opt/StarUML/resources/app.asar
            '';
          });
          # kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
          #   kservice = kprev.kservice.overrideAttrs {
          #     patches = [./canonical.patch];
          #   };
          # });
        })
      ];
    }
  ];
}