{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.power.policy;
in
{
  options = {
    power.policy = mkOption {
      type = types.nullOr (types.enum [ "always-on" "previous" "always-off" ]);
      default = null;
      description = "Set power policy to use via IPMI.";
    };
  };

  config = mkIf (cfg != null) {
    systemd.services."power-policy" = {
      description = "Set power policy to use via IPMI";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ipmitool}/bin/ipmitool chassis policy ${cfg}";
        Type = "oneshot";
        Restart = "on-failure";
        RestartSec = "5s";
        StartLimitBurst = "10";
        StartLimitIntervalSec = "10m";
      };
    };
  };
}
