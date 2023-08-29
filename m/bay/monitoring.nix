{ config, lib, ... }:

{
  # We need access to the devices to monitor the disk space
  systemd.services.prometheus-node-exporter.serviceConfig.PrivateDevices = lib.mkForce false;
  systemd.services.prometheus-node-exporter.serviceConfig.ProtectHome = lib.mkForce "read-only";

  # Required to allow the smartctl exporter to read the nvme0 character device,
  # see the commit message on:
  # https://github.com/NixOS/nixpkgs/commit/12c26aca1fd55ab99f831bedc865a626eee39f80
  services.udev.extraRules = ''
    SUBSYSTEM=="nvme", KERNEL=="nvme[0-9]*", GROUP="disk"
  '';

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
      smartctl.enable = true;
    };
  };
}
