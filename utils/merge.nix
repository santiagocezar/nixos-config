# HEAVILY inspired by sodiboo's config

lib:

with builtins;
rec {
  # Imports every .mod.nix file in some directory tree
  importAll = dir: lib.pipe dir [
    lib.filesystem.listFilesRecursive
    (filter (path: lib.hasSuffix ".mod.nix" "${path}"))
    (map (path: import path))
  ];

  # Utility functions to work with values that
  # may or may not be lists.

  # Wraps a single value in a list, only if
  # it's not already a list.
  ensureList = l:
    if isList l
      then l
      else [l];

  # Concatenates both lists and single values
  # into a flat list.
  concatAnyhow = value:
    concatLists (map (f: assert isList f; f) (map ensureList value));

  # Applies f to a list or a single value, in
  # that case it wraps it into a list.
  mapAnyhow = f: value:
    map f (ensureList value);

  # Concatenates both the NixOS and HM configs.
  concatConfig = prev: this:
    {
      nixos = concatAnyhow [
        (prev.nixos or [])
        (this.nixos or [])
        (lib.flatten (mapAnyhow (getAttr "nixos") this.use or []))
      ];
      home = concatAnyhow [
        (prev.home or [])
        (this.home or [])
        (lib.flatten (mapAnyhow (getAttr "home") this.use or []))
      ];
    } // (if (prev ? system || this ? system) then {
      system = prev.system or this.system;
    } else {});

  # Concatenates a list of configs.
  concatConfigList = foldl' concatConfig {};

  # Concatenates the configs for each host from
  # every module into one big module per host.
  mergeModules = modules:
    zipAttrsWith (lib.const concatConfigList) modules;



  fromDirectory = dir: inputs:
    let
      normalizeModule = mod:
        if builtins.isFunction mod
        then mod { inherit inputs final; }
        else mod;
      modules = map normalizeModule (importAll dir);

      final = mergeModules modules;
    in
      final;
}
