# inspired by sodiboo

with builtins;
let
  importPaths = paths: inputs: map (path:
    let
      mod = import path;
    in
      if isFunction mod then mod inputs else mod
  ) paths;
  merge = prev: this:
    assert (this ? nixos) -> (isList this.nixos);
    assert (this ? home) -> (isList this.home);
    {
      nixos = prev.nixos or [] ++ this.nixos or [];
      home = prev.home or [] ++ this.home or [];
    } // (if (prev ? system || this ? system) then {
      system = prev.system or this.system;
    } else {});
  mergeHosts = modules: zipAttrsWith (_host: foldl' merge {}) modules;
  mergeShared = merged: mapAttrs (_host: merge merged.shared) (builtins.removeAttrs merged ["shared"]);
  mergeModules = modules: mergeShared (mergeHosts modules);
in

{nixpkgs, ...}@inputs: paths:

mapAttrs (host: config:
    nixpkgs.lib.nixosSystem {
      system = config.system;
      specialArgs = { inherit inputs; };
      modules = config.nixos ++ [
        {
          networking.hostName = host;
          system.stateVersion = "23.11";
          _module.args.home_modules = config.home;
        }
      ];
    }
) (mergeModules (importPaths paths inputs))
