{ config, pkgs, lib, ... }:

let

  # the lttng btrfs probe crashes at compile time because of an undefined
  # function. This disables the btrfs tracepoints to avoid the issue.
  lttng-modules-fixed = config.boot.kernelPackages.lttng-modules.overrideAttrs (finalAttrs: previousAttrs: {
    patchPhase = (lib.optionalString (previousAttrs ? patchPhase) previousAttrs.patchPhase) + ''
      substituteInPlace src/probes/Kbuild \
        --replace "  obj-\$(CONFIG_LTTNG) += lttng-probe-btrfs.o" "  #obj-\$(CONFIG_LTTNG) += lttng-probe-btrfs.o"
    '';
  });
in {

  # add the lttng tools and modules to the system environment
  boot.extraModulePackages = [ lttng-modules-fixed ];
  environment.systemPackages = with pkgs; [
    lttng-tools lttng-ust babeltrace
  ];

  # start the lttng root daemon to manage kernel events
  systemd.services.lttng-sessiond = {
    wantedBy = [ "multi-user.target" ];
    description = "LTTng session daemon for the root user";
    serviceConfig = {
      User = "root";
      ExecStart = ''
        ${pkgs.lttng-tools}/bin/lttng-sessiond
      '';
    };
  };

  # members of the tracing group can use the lttng-provided kernel events
  # without root permissions
  users.groups.tracing.members = [ "arocanon" ];
}
