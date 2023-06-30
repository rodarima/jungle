{ pkgs, ... }:

{
  services.ntp.enable = true;

  # Use the NTP server at BSC, as we don't have direct access
  # to the outside world
  networking.timeServers = [ "84.88.52.36" ];
}
