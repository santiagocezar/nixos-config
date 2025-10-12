{
  _srv.nixos = { config, pkgs, ... }: {
    services.caddy = {
      enable = true;
      virtualHosts."e123.cez.ar".extraConfig = ''
        handle /aria2/* {
          root * "${pkgs.ariang}/share/ariang/"
          file_server
        }
        handle /aria2rpc {
          reverse_proxy :6800/jsonrpc
        }
      '';
    };
    networking.firewall.allowedTCPPorts = [
      80 443
    ];
  };
}
