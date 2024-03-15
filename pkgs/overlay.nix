final: prev:
{
  # Set MPICH as default
  mpi = final.mpich;

  # Configure the network for MPICH
  mpich = with final; let
    # pmix comes with the libraries in .out and headers in .dev
    pmixAll = symlinkJoin {
      name = "pmix-all";
      paths = [ pmix.dev pmix.out ];
    };
  in prev.mpich.overrideAttrs (old: {
    patches = [
      # See https://github.com/pmodels/mpich/issues/6946
      ./mpich-fix-hwtopo.patch
    ];
    buildInput = old.buildInputs ++ [
      libfabric
      pmixAll
    ];
    configureFlags = [
      "--enable-shared"
      "--enable-sharedlib"
      "--with-pm=no"
      "--with-device=ch4:ofi"
      "--with-pmi=pmix"
      "--with-pmix=${pmixAll}"
      "--with-libfabric=${libfabric}"
      "--enable-g=log"
    ] ++ lib.optionals (lib.versionAtLeast gfortran.version "10") [
      "FFLAGS=-fallow-argument-mismatch" # https://github.com/pmodels/mpich/issues/4300
      "FCFLAGS=-fallow-argument-mismatch"
    ];
  });

  slurm = prev.slurm.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      # See https://bugs.schedmd.com/show_bug.cgi?id=19324
      ./slurm-rank-expansion.patch
    ];
  });

  prometheus-slurm-exporter = prev.callPackage ./slurm-exporter.nix { };
}
