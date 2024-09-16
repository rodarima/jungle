{ theFlake, pkgs, ... }:
let
  website = pkgs.stdenv.mkDerivation {
    name = "jungle-web";
    src = theFlake;
    buildInputs = [ pkgs.hugo ];
    buildPhase = ''
      cd web
      rm -rf public/
      hugo
    '';
    installPhase = ''
      cp -r public $out
    '';
  };
in
{
  services.nginx = {
    enable = true;
    virtualHosts."jungle.bsc.es" = {
      root = "${website}";
      listen = [
        {
          addr = "127.0.0.1";
          port = 80;
        }
      ];
      extraConfig = ''
        location /git {
          rewrite ^/git$ / break;
          rewrite ^/git/(.*) /$1 break;
          proxy_pass http://127.0.0.1:3000;
          proxy_redirect http:// $scheme://;
        }
        location /cache {
          rewrite ^/cache(.*) /$1 break;
          proxy_pass http://127.0.0.1:5000;
          proxy_redirect http:// $scheme://;
        }
        location /lists {
          proxy_pass http://127.0.0.1:8081;
          proxy_redirect http:// $scheme://;
        }
        location /grafana {
          proxy_pass http://127.0.0.1:2342;
          proxy_redirect http:// $scheme://;
          # Websockets
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
        }
        location ~ ^/~(.+?)(/.*)?$ {
          alias /ceph/home/$1/public_html$2;
          index  index.html index.htm;
          autoindex on;
          absolute_redirect off;
        }
        location /p/ {
          alias /ceph/p/;
        }
      '';
    };
  };
}
