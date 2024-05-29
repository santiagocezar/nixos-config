# inspired by sodiboo

with builtins;
let
  # from <nixpkgs>/lib/trivial.nix
  pipe = foldl' (x: f: f x);
  const =
    x:
    y: x;
  id = x: x;

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
      nixos = (prev.nixos or []) ++ (this.nixos or []);
      home = (prev.home or []) ++ (this.home or []);
    } // (if (prev ? system || this ? system) then {
      system = prev.system or this.system;
    } else {});
  mergeHostList = foldl' merge {};
  mergeHosts = modules: zipAttrsWith (const mergeHostList) modules;
  realGroupNames = groups: map (g: "_${g}") (attrNames groups);
  /*
  transposeGroups {
    pc = ["e102" "e123"];
    laptop = ["e102"];
    srv = ["e1001"];
  } => {
    e1001 = [ "_srv" ];
    e102 = [ "_laptop" "_pc" ];
    e123 = [ "_pc" ];
  }
  */
  transposeGroups = groupToHost:
    zipAttrsWith (const id)
      (concatMap
        (group:
          map
            (host: {"${host}" = "_${group}";})
            groupToHost.${group})
        (attrNames
          groupToHost));
  mergeModules =
    modules: groupToHost:
      let
        # groups are treated as individual hosts
        almostMerged = mergeHosts modules;
        groupNames = realGroupNames groupToHost;
        valueGroups = groups: pipe groups [
          (filter (g: almostMerged ? ${g}))
          (map (g: almostMerged.${g}))
          mergeHostList
        ];
        ungrouped = mapAttrs (const valueGroups) (transposeGroups groupToHost);
      in
        mergeHosts [ungrouped (removeAttrs almostMerged groupNames)];
in

{nixpkgs, ...}@inputs: paths: groups:

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
) (mergeModules (importPaths paths inputs) groups)
