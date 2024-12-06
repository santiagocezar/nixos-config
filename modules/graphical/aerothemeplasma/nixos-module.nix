{ lib, config, pkgs, ... }:

let
  cfg = config.aerothemeplasma;
  src = import ./src.nix pkgs;
  callPackage = pkg: opts: pkgs.callPackage pkg (opts // { src = src; });
in

{
  options.aerothemeplasma.enable = lib.mkEnableOption "Enable AeroThemePlasma for Plasma 6";

  # TODO: default tooltip, mimes, fontconfig

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.kdePackages.qtstyleplugin-kvantum
      (callPackage ./cursors.nix {})
      (callPackage ./icons.nix {})
      (callPackage ./kvantum.nix {})
      (callPackage ./sevenstart.nix {})
      (callPackage ./sounds.nix {})
    ];

#     boot.plymouth = {
#       theme = lib.mkForce "smod";
#       themePackages = [
#         (callPackage ./plymouth.nix {})
#       ];
#     };
  };
}
