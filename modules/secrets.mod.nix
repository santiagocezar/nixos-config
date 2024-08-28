{ inputs, ... }: {
  _all.nixos = {
  
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    
    sops.defaultSopsFile = ./secrets.yaml;

    sops.age.keyFile = "/home/santi/.config/sops/age/keys.txt";
  };
  e1001.nixos = {
    sops.secrets."aria2-rpc-token.txt" = {
      mode = "0440";
      group = "aria2";
    };
    sops.secrets."dns-token" = {
      mode = "0440";
      group = "inadyn";
    };
  };
}
