final: prev:
{
  # Set MPICH as default
  mpi = final.mpich;

  # Configure the network for MPICH
  mpich = with final; prev.mpich.overrideAttrs (old: {
    buildInput = old.buildInputs ++ [
      libfabric
      pmix
    ];
    configureFlags = [
      "--enable-shared"
      "--enable-sharedlib"
      "--with-pm=no"
      "--with-device=ch4:ofi"
      "--with-pmi=pmix"
      "--with-pmix=${final.pmix}"
      "--with-libfabric=${final.libfabric}"
      "--enable-g=log"
    ] ++ lib.optionals (lib.versionAtLeast gfortran.version "10") [
      "FFLAGS=-fallow-argument-mismatch" # https://github.com/pmodels/mpich/issues/4300
      "FCFLAGS=-fallow-argument-mismatch"
    ];
  });

  prometheus-slurm-exporter = prev.callPackage ./slurm-exporter.nix { };
}
