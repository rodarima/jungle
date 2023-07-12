{ pkgs, lib, ... }:

let
  #fcs-devel = pkgs.linuxPackages_custom {
  #   version = "6.2.8";
  #   src = /mnt/data/kernel/fcs/kernel/src;
  #   configfile = /mnt/data/kernel/fcs/kernel/configs/defconfig;
  #};

  #fcsv1 = fcs-kernel "bc11660676d3d68ce2459b9fb5d5e654e3f413be" false;
  #fcsv2 = fcs-kernel "db0f2eca0cd57a58bf456d7d2c7d5d8fdb25dfb1" false;
  #fcsv1-lockdep = fcs-kernel "bc11660676d3d68ce2459b9fb5d5e654e3f413be" true;
  #fcsv2-lockdep = fcs-kernel "db0f2eca0cd57a58bf456d7d2c7d5d8fdb25dfb1" true;
  #fcs-kernel = gitCommit: lockdep: pkgs.linuxPackages_custom {
  #   version = "6.2.8";
  #   src = builtins.fetchGit {
  #     url = "git@bscpm03.bsc.es:ompss-kernel/linux.git";
  #     rev = gitCommit;
  #     ref = "fcs";
  #   };
  #   configfile = if lockdep then ./configs/lockdep else ./configs/defconfig;
  #};

  kernel = nixos-fcsv3;

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

  # always use fcs_sched_setaffinity
  #nixos-debug = nixos-fcs-kernel {gitCommit = "7d0bf285fca92badc8df3c9907a9ab30db4418aa";};
  # remove need_check_cgroup
  #nixos-debug = nixos-fcs-kernel {gitCommit = "4cc4efaab5e4a0bfa3089e935215b981c1922919";};
  # merge again fcs_wake and fcs_wait
  #nixos-debug = nixos-fcs-kernel {gitCommit = "40c6f72f4ae54b0b636b193ac0648fb5730c810d";};
  # start from scratch, this is the working version with split fcs_wake and fcs_wait
  nixos-debug = nixos-fcs-kernel {gitCommit = "c9a39d6a4ca83845b4e71fcc268fb0a76aff1bdf"; branch = "fcs-test"; };

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
    ./lttng.nix
    ./perf.nix
  ];
  boot.kernelPackages = lib.mkForce kernel;

  # disable all cpu mitigations
  boot.kernelParams = [
    "mitigations=off"
  ];
  
  # enable memory overcommit, needed to build a taglibc system using nix after
  # increasing the openblas memory footprint
  boot.kernel.sysctl."vm.overcommit_memory" = 1;
}
