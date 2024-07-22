{
  # Shutdown all machines on August 2nd at 11:00 AM, so we can protect the
  # hardware from spurious electrical peaks on the yearly electrical cut for
  # manteinance that starts on August 4th.
  systemd.timers.august-shutdown = {
    description = "Shutdown on August 2nd for maintenance";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-08-02 11:00:00";
      RandomizedDelaySec = "10min";
      Unit = "systemd-poweroff.service";
    };
  };
}
