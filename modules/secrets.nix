{ sops-nix, ... }: {
  _all.nixos = {
  
    imports = [
      sops-nix.nixosModules.sops
    ];
    
    sops.defaultSopsFile = ../resources/secrets.yaml;

    sops.age.keyFile = "/home/santi/.config/sops/age/keys.txt";

    sops.secrets."aria2-rpc-token.txt" = {
      mode = "0440";
      group = "aria2";
    };
  };
}
