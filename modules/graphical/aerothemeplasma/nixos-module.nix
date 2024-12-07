{ lib, config, pkgs, ... }:

let
  cfg = config.aerothemeplasma;
  callPackage = pkgs.lib.callPackageWith (pkgs // aeroPkgs);
  aeroPkgs = {  
    src = callPackage ./src.nix {};
    aero-cursors = callPackage ./appearance/cursors.nix {};
    aero-icons = callPackage ./appearance/icons.nix {};
    aero-kvantum-theme = callPackage ./appearance/kvantum.nix {};
    aero-plasma-theme = callPackage ./appearance/plasma.nix {};
    aero-sounds = callPackage ./appearance/sounds.nix {};
    aero-plymouth-theme = callPackage ./boot/plymouth.nix {};
    aero-sddm-theme = callPackage ./boot/sddm.nix {};
    sevenstart-plasmoid = callPackage ./plasmoids/sevenstart.nix {};
    kwin-effect-smodglow = callPackage ./kwin/kwin-effect-smodglow.nix {};
    kwin-effect-smodsnap = callPackage ./kwin/kwin-effect-smodsnap.nix {};
    kwin-effect-forceblur = callPackage ./kwin/kwin-effects-forceblur.nix {};
    kwin-other-effects = callPackage ./kwin/kwin-other-effects.nix {};
    kwin-smod-decoration = callPackage ./kwin/kwin-decoration.nix {};
  };
in

{
  options.aerothemeplasma.enable = lib.mkEnableOption "Enable AeroThemePlasma for Plasma 6";

  # TODO: default tooltip, mimes, fontconfig

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with (pkgs // aeroPkgs); [
      kdePackages.qtstyleplugin-kvantum
      aero-cursors
      aero-icons
      aero-kvantum-theme
      aero-plasma-theme
      aero-sounds
      aero-sddm-theme
      sevenstart-plasmoid
      kwin-effect-smodglow
      kwin-effect-smodsnap
      kwin-effect-forceblur
      kwin-other-effects
      kwin-smod-decoration
    ];
    /*
    nixpkgs.overlays = [
      (final: prev: {
        kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
          breeze = prev.callPackage ./kwin-decoration.nix { src = src; kdePackages = kprev; };
        });
      })
    ];*/
    
    services.displayManager.sddm = {
      theme = "sddm-theme-mod";
      extraPackages = [  ];
    };
    boot.plymouth = {
      enable = true;
      theme = "smod";
      themePackages = [
        aeroPkgs.aero-plymouth-theme
      ];
    };
  };
}
