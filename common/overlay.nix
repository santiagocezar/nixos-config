final: prev: {
#   obs-studio = prev.wrapOBS {
#     plugins = with prev.obs-studio-plugins; [
#       obs-vaapi
#     ];
#   };
#   retroarch = prev.retroarch.override {
#     cores = with final.libretro; [
#       genesis-plus-gx
#       snes9x
#       beetle-psx-hw
#     ];
#   };
#   # Add SDL2_gfx to the uh, sandbox? used by `steam-run`
#   steam = prev.steam.override {
#     extraPkgs = pkgs: with pkgs; [
#       SDL2_gfx
#       noto-fonts
#       noto-fonts-cjk
#       noto-fonts-emoji
#       dejavu_fonts
#     ];
#   };
  kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
    kservice = kprev.kservice.overrideAttrs {
      patches = [./canonical.patch];
    };
  });
}
