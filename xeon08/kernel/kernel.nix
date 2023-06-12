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

  kernel = nixos-fcsv2;

  nixos-fcs-kernel = {gitCommit, lockStat ? false, preempt ? false}: pkgs.linuxPackagesFor (pkgs.buildLinux rec {
    version = "6.2.8";
    src = builtins.fetchGit {
      url = "git@bscpm03.bsc.es:ompss-kernel/linux.git";
      rev = gitCommit;
      ref = "fcs";
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
  nixos-fcsv1-lockstat = nixos-fcs-kernel {
    gitCommit = "bc11660676d3d68ce2459b9fb5d5e654e3f413be";
    lockStat = true;
  };
  nixos-fcsv2-lockstat = nixos-fcs-kernel {
    gitCommit = "db0f2eca0cd57a58bf456d7d2c7d5d8fdb25dfb1";
    lockStat = true;
  };
  nixos-fcsv2-lockstat-preempt = nixos-fcs-kernel {
    gitCommit = "db0f2eca0cd57a58bf456d7d2c7d5d8fdb25dfb1";
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
}
