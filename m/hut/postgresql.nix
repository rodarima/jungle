{ lib, ... }:

{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "perftestsdb" ];
    ensureUsers = [
      { name = "anavarro"; ensureClauses.superuser = true; }
      { name = "rarias";   ensureClauses.superuser = true; }
      { name = "grafana"; }
    ];
    authentication = ''
      #type  database     DBuser    auth-method
      local  perftestsdb  rarias    trust
      local  perftestsdb  anavarro  trust
      local  perftestsdb  grafana   trust
    '';
  };
}
