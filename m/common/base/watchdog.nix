{ ... }:

{
  # The boards have a BMC watchdog controlled by IPMI
  boot.kernelModules = [ "ipmi_watchdog" ];

  # Enable systemd watchdog with 30 s interval
  systemd.watchdog.runtimeTime = "30s";
}
