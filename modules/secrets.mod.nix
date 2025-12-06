{ sources, ... }:
let
  sops-nix = import sources.sops-nix;
in
{
  e123.nixos = {

    imports = [
      sops-nix.nixosModules.sops
    ];

    sops.defaultSopsFile = ./secrets.yaml;

    fileSystems."/home".neededForBoot = true;
    sops.age.keyFile = "/home/santi/.config/sops/age/keys.txt";
  };
  _srv.nixos = {
    sops.secrets."aria2-rpc-token.txt" = {
      mode = "0440";
      group = "aria2";
    };
    sops.secrets."dns-token" = {
      mode = "0440";
      group = "inadyn";
    };
    sops.secrets."syncthing-password" = {
      mode = "0440";
      group = "syncthing";
    };
    sops.secrets."ms-token" = {
      mode = "0440";
      group = "syncthing";
    };
    sops.secrets."ssh-key" = {
      mode = "0400";
    };
    sops.secrets."ssh-pub" = {
      mode = "0400";
    };
  };
}
