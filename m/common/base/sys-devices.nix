{
  nix.settings.system-features = [ "sys-devices" ];

  programs.nix-required-mounts.enable = true;
  programs.nix-required-mounts.allowedPatterns.sys-devices.paths = [
    "/sys/devices/system/cpu"
    "/sys/devices/system/node"
  ];
}
