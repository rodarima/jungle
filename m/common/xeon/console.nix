{
  # Restart the serial console
  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };

  # Enable serial console
  boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,115200"
  ];
}
