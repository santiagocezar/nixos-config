# inspired by sodiboo

with builtins;
let
  # from <nixpkgs>/lib/trivial.nix
  pipe = foldl' (x: f: f x);
  const =
    x:
    y: x;
  id = x: x;
  # from <nixpkgs>/lib/strings.nix
  hasSuffix =
    # Suffix to check for
    suffix:
    # Input string
    content:
    let
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
      lenContent >= lenSuffix
      && substring (lenContent - lenSuffix) lenContent content == suffix;


  importAll = dir: inputs: pipe dir [
    readDir
    attrNames
    (map (path: /${dir}/${path}))
    (filter (path: hasSuffix ".nix" "${path}"))
    (map (path: import path))
    (map (mod: if isFunction mod then mod inputs else mod))
  ];
  ensureList = l:
      if isList l
        then l
        else [l];
  merge = prev: this:
    {
      nixos = (ensureList prev.nixos or []) ++ (ensureList this.nixos or []);
      home = (ensureList prev.home or []) ++ (ensureList this.home or []);
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

{ from, groups, inputs }:

let
  inherit (inputs) nixpkgs home-manager;
  modules = importAll from inputs;
  merged = mergeModules modules groups;
in
  {
    nixosConfigurations = mapAttrs (host: config:
      nixpkgs.lib.nixosSystem {
        system = config.system;
        specialArgs = {
          smallPkgs = import inputs.nixpkgs-small {
            inherit (config) system;
            config.allowUnfree = true;
          };
        };
        modules = config.nixos ++ [
          {
            networking.hostName = host;
            system.stateVersion = "23.11";
          }
        ];
      }
    ) merged;

    # yes, this is using hostnames instead of usernames
    homeConfigurations = mapAttrs (host: config:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${config.system};
        modules = config.home ++ [
          {
            # i guess these two have to be hardcoded
            home.username = "santi";
            home.homeDirectory = "/home/santi";
            home.stateVersion = "23.11";
          }
        ];
      }
    ) merged;
  }
