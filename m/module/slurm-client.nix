{ config, pkgs, lib, ... }:

let
  suspendProgram = pkgs.writeScript "suspend.sh" ''
    #!/usr/bin/env bash
    exec 1>>/var/log/power_save.log 2>>/var/log/power_save.log
    set -x
    export "PATH=/run/current-system/sw/bin:$PATH"
    echo "$(date) Suspend invoked $0 $*" >> /var/log/power_save.log
    hosts=$(scontrol show hostnames $1)
    for host in $hosts; do
      echo Shutting down host: $host
      ipmitool -I lanplus -H ''${host}-ipmi -P "" -U "" chassis power off
    done
  '';

  resumeProgram = pkgs.writeScript "resume.sh" ''
    #!/usr/bin/env bash
    exec 1>>/var/log/power_save.log 2>>/var/log/power_save.log
    set -x
    export "PATH=/run/current-system/sw/bin:$PATH"
    echo "$(date) Suspend invoked $0 $*" >> /var/log/power_save.log
    hosts=$(scontrol show hostnames $1)
    for host in $hosts; do
      echo Starting host: $host
      ipmitool -I lanplus -H ''${host}-ipmi -P "" -U "" chassis power on
    done
  '';

in {
  systemd.services.slurmd.serviceConfig = {
    # Kill all processes in the control group on stop/restart. This will kill
    # all the jobs running, so ensure that we only upgrade when the nodes are
    # not in use. See:
    # https://github.com/NixOS/nixpkgs/commit/ae93ed0f0d4e7be0a286d1fca86446318c0c6ffb
    # https://bugs.schedmd.com/show_bug.cgi?id=2095#c24
    KillMode = lib.mkForce "control-group";
  };

  services.slurm = {
    client.enable = true;
    controlMachine = "hut";
    clusterName = "jungle";
    nodeName = [
      "owl[1,2]  Sockets=2 CoresPerSocket=14 ThreadsPerCore=2 Feature=owl"
      "hut       Sockets=2 CoresPerSocket=14 ThreadsPerCore=2"
    ];

    partitionName = [
      "owl Nodes=owl[1-2] Default=YES MaxTime=INFINITE State=UP"
      "all Nodes=owl[1-2],hut Default=NO MaxTime=INFINITE State=UP"
    ];

    # See slurm.conf(5) for more details about these options.
    extraConfig = ''
      # Use PMIx for MPI by default. It works okay with MPICH and OpenMPI, but
      # not with Intel MPI. For that use the compatibility shim libpmi.so
      # setting I_MPI_PMI_LIBRARY=$pmix/lib/libpmi.so while maintaining the PMIx
      # library in SLURM (--mpi=pmix). See more details here:
      # https://pm.bsc.es/gitlab/rarias/jungle/-/issues/16
      MpiDefault=pmix

      # When a node reboots return that node to the slurm queue as soon as it
      # becomes operative again.
      ReturnToService=2

      # Track all processes by using a cgroup
      ProctrackType=proctrack/cgroup

      # Enable task/affinity to allow the jobs to run in a specified subset of
      # the resources. Use the task/cgroup plugin to enable process containment.
      TaskPlugin=task/affinity,task/cgroup

      # Power off unused nodes until they are requested
      SuspendProgram=${suspendProgram}
      SuspendTimeout=60
      ResumeProgram=${resumeProgram}
      ResumeTimeout=300
      SuspendExcNodes=hut

      # Turn the nodes off after 1 hour of inactivity
      SuspendTime=3600

      # Reduce port range so we can allow only this range in the firewall
      SrunPortRange=60000-61000
    '';
  };

  age.secrets.mungeKey = {
    file = ../../secrets/munge-key.age;
    owner = "munge";
    group = "munge";
  };

  services.munge = {
    enable = true;
    password = config.age.secrets.mungeKey.path;
  };
}