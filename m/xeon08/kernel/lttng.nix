{ config, pkgs, lib, ... }:

let

  # The lttng btrfs probe crashes at compile time because of an undefined
  # function. This disables the btrfs tracepoints to avoid the issue.

  # Also enable lockdep tracepoints, this is disabled by default because it
  # does not work well on architectures other than x86_64 (i think that arm) as
  # I was told on the mailing list.
  lttng-modules-fixed = config.boot.kernelPackages.lttng-modules.overrideAttrs (finalAttrs: previousAttrs: {
    patchPhase = (lib.optionalString (previousAttrs ? patchPhase) previousAttrs.patchPhase) + ''
      # disable btrfs
      substituteInPlace src/probes/Kbuild \
        --replace "  obj-\$(CONFIG_LTTNG) += lttng-probe-btrfs.o" "  #obj-\$(CONFIG_LTTNG) += lttng-probe-btrfs.o"

      # enable lockdep tracepoints
      substituteInPlace src/probes/Kbuild \
        --replace "#ifneq (\$(CONFIG_LOCKDEP),)"                  "ifneq (\$(CONFIG_LOCKDEP),)" \
        --replace "#  obj-\$(CONFIG_LTTNG) += lttng-probe-lock.o" "  obj-\$(CONFIG_LTTNG) += lttng-probe-lock.o" \
        --replace "#endif # CONFIG_LOCKDEP"                       "endif # CONFIG_LOCKDEP"
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
}
