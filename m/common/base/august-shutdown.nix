{
  # Shutdown all machines on August 3rd at 22:00, so we can protect the
  # hardware from spurious electrical peaks on the yearly electrical cut for
  # manteinance that starts on August 4th.
  systemd.timers.august-shutdown = {
    description = "Shutdown on August 3rd for maintenance";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-08-03 22:00:00";
      RandomizedDelaySec = "10min";
      Unit = "systemd-poweroff.service";
    };
  };
}
