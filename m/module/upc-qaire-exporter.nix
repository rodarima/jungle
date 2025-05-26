{ config, lib, pkgs, ... }:

with lib;

{
  systemd.services."prometheus-upc-qaire-exporter" = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = mkDefault "always";
      PrivateTmp = mkDefault true;
      WorkingDirectory = mkDefault "/tmp";
      DynamicUser = mkDefault true;
      ExecStart = "${pkgs.upc-qaire-exporter}/bin/upc-qaire-exporter";
    };
  };
}
