{
  _srv.nixos = { config, pkgs, ... }: {
    services.caddy = {
      enable = true;
      virtualHosts."e123.cez.ar".extraConfig = ''
        handle_path /aria2/* {
          root * "${pkgs.ariang}/share/ariang"
          file_server browse
        }
        handle_path /aria2rpc {
          reverse_proxy :6800/jsonrpc {
            header_down X-Real-IP {http.request.remote}
          }
        }
      '';
    };
    networking.firewall.allowedTCPPorts = [
      80 443
    ];
  };
}
