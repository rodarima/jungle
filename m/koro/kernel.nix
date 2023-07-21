{ pkgs, lib, ... }:

let
  kernel = nixos-fcsv4;

  nixos-fcs-kernel = {gitCommit, lockStat ? false, preempt ? false, branch ? "fcs"}: pkgs.linuxPackagesFor (pkgs.buildLinux rec {
    version = "6.2.8";
    src = builtins.fetchGit {
      url = "git@bscpm03.bsc.es:ompss-kernel/linux.git";
      rev = gitCommit;
      ref = branch;
    };
    structuredExtraConfig = with lib.kernel; {
      # add general custom kernel options here
    } // lib.optionalAttrs lockStat {
      LOCK_STAT = yes;
    } // lib.optionalAttrs preempt {
      PREEMPT = lib.mkForce yes;
      PREEMPT_VOLUNTARY = lib.mkForce no;
    };
    kernelPatches = [];
    extraMeta.branch = lib.versions.majorMinor version;
  });

  nixos-fcsv1 = nixos-fcs-kernel {gitCommit = "bc11660676d3d68ce2459b9fb5d5e654e3f413be";};
  nixos-fcsv2 = nixos-fcs-kernel {gitCommit = "db0f2eca0cd57a58bf456d7d2c7d5d8fdb25dfb1";};
  nixos-fcsv3 = nixos-fcs-kernel {gitCommit = "6c17394890704c3345ac1a521bb547164b36b154";};
  nixos-fcsv4 = nixos-fcs-kernel {gitCommit = "c94c3d946f33ac3e5782a02ee002cc1164c0cb4f";};

  nixos-fcsv1-lockstat = nixos-fcs-kernel {
    gitCommit = "bc11660676d3d68ce2459b9fb5d5e654e3f413be";
    lockStat = true;
  };
  nixos-fcsv2-lockstat = nixos-fcs-kernel {
    gitCommit = "db0f2eca0cd57a58bf456d7d2c7d5d8fdb25dfb1";
    lockStat = true;
  };
  nixos-fcsv3-lockstat = nixos-fcs-kernel {
    gitCommit = "6c17394890704c3345ac1a521bb547164b36b154";
    lockStat = true;
  };
  nixos-fcsv3-lockstat-preempt = nixos-fcs-kernel {
    gitCommit = "6c17394890704c3345ac1a521bb547164b36b154";
    lockStat = true;
    preempt = true;
  };
  latest = pkgs.linuxPackages_latest;

in {
  imports = [
    ../eudy/kernel/lttng.nix
    ../eudy/kernel/perf.nix
  ];
  boot.kernelPackages = lib.mkForce kernel;

  # disable all cpu mitigations
  boot.kernelParams = [
    "mitigations=off"
  ];
  
  # enable memory overcommit, needed to build a taglibc system using nix after
  # increasing the openblas memory footprint
  boot.kernel.sysctl."vm.overcommit_memory" = lib.mkForce 1;
}
