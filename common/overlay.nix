final: prev: {
#   obs-studio = prev.wrapOBS {
#     plugins = with prev.obs-studio-plugins; [
#       obs-vaapi
#     ];
#   };
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
  kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
    kservice = kprev.kservice.overrideAttrs {
      patches = [./canonical.patch];
    };
  });
}
