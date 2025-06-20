{ config, lib, pkgs, ... }:

{
  options = {
    services.amd-uprof = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable AMD uProf.";
      };
    };
  };

  # Only setup amd-uprof if enabled
  config = lib.mkIf config.services.amd-uprof.enable {

    # First make sure that we add the module to the list of available modules
    # in the kernel matching the same kernel version of this configuration.
    boot.extraModulePackages = with config.boot.kernelPackages; [ amd-uprof-driver ];
    boot.kernelModules = [ "AMDPowerProfiler" ];

    # Make the userspace tools available in $PATH.
    environment.systemPackages = with pkgs; [ amd-uprof ];

    # The AMDPowerProfiler module doesn't create the /dev device nor it emits
    # any uevents, so we cannot use udev rules to automatically create the
    # device. Instead, we run a systemd unit that does it after loading the
    # modules.
    systemd.services.amd-uprof-device = {
      description = "Create /dev/AMDPowerProfiler device";
      after = [ "systemd-modules-load.service" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig.ConditionPathExists = [
          "/proc/AMDPowerProfiler/device"
          "!/dev/AMDPowerProfiler"
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "add-amd-uprof-dev.sh" ''
          mknod /dev/AMDPowerProfiler -m 666 c $(< /proc/AMDPowerProfiler/device) 0
        '';
        ExecStop = pkgs.writeShellScript "remove-amd-uprof-dev.sh" ''
          rm -f /dev/AMDPowerProfiler
        '';
      };
    };
  };
}
