{
  _pc.nixos = {
    imports = [ ./aerothemeplasma/nixos-module.nix ];
    aerothemeplasma.enable = true;
  };
  e123.home = {
  };
}
