{ ... }:

{
  services.slurm = {
    client.enable = true;
    controlMachine = "hut";
    clusterName = "jungle";
    nodeName = [
      "owl[1,2]  Sockets=2 CoresPerSocket=14 ThreadsPerCore=2 Feature=owl"
      "hut       Sockets=2 CoresPerSocket=14 ThreadsPerCore=2"
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
    '';
  };
}
