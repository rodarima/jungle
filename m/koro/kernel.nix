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

  kernel = nixos-fcs;

  nixos-fcs-kernel = lib.makeOverridable ({gitCommit, lockStat ? false, preempt ? false, branch ? "fcs"}: pkgs.linuxPackagesFor (pkgs.buildLinux rec {
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
  }));

  nixos-fcs = nixos-fcs-kernel {gitCommit = "8a09822dfcc8f0626b209d6d2aec8b5da459dfee";};
  nixos-fcs-lockstat = nixos-fcs.override {
    lockStat = true;
  };
  nixos-fcs-lockstat-preempt = nixos-fcs.override {
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
  boot.kernel.sysctl."vm.overcommit_memory" = 1;
}
