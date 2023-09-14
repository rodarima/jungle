{ ... }:

{
  networking.firewall = {
    # Required for PMIx in SLURM, we should find a better way
    allowedTCPPortRanges = [ { from=1024; to=65535; } ];
  };
}
