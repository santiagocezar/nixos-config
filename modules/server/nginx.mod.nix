{
  e1001.nixos = { config, pkgs, ... }: {
    services.nginx = {
      enable = true;
      virtualHosts."play.cez.ar" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
      virtualHosts."e1001.cez.ar" = {
#       virtualHosts."e1001.cez.ar" = {
        locations."/aria2/" = {
          alias = "${pkgs.ariang}/share/ariang/";
        };
        locations."/aria2rpc" = {
          proxyPass = "http://127.0.0.1:6800/jsonrpc";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_redirect   off;
            proxy_set_header X-Real-IP       $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host            $host;
          '';
        };
      };
    };
    networking.firewall.allowedTCPPorts = [
      80 443
    ];
  };
}
