configs:

with builtins;
let
  isos = listToAttrs
    (map
      (host: {
        name = "${host}iso";
        value = configs.${host}.extendModules {
          modules = [
            ({ pkgs, modulesPath, lib, ... }: {
              imports = [
                "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
              ];

              isoImage.squashfsCompression = "gzip -Xcompression-level 1";

              networking.wireless.enable = false;

              # use the latest Linux kernel
              boot.kernelPackages = pkgs.linuxPackages_latest;

              # Needed for https://github.com/NixOS/nixpkgs/issues/58959
              boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
            })
          ];
        };
      }
  ) (attrNames configs));
in
  configs // isos
