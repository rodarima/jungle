---
title: "Hut"
description: "Control node"
date: 2023-06-13T19:36:57+02:00
---

![Hut](hut.jpg)

From the hut we monitor and control other nodes. It consist of one node only,
which is available at `hut` or `xeon07`. It runs the following services:

- Prometheus: to store the monitoring data.
- Grafana: to plot the data in the web browser.
- Slurmctld: to manage the SLURM nodes.
- Gitlab runner: to run CI jobs from Gitlab.
- Nix binary cache: to serve cached nix builds

This node is prone to interruptions from all the services it runs, so it is not
a good candidate for low noise executions.

# Binary cache

We provide a binary cache in `hut`, with the aim of avoiding unnecessary
recompilation of packages.

The cache should contain common packages from bscpkgs, but we don't provide
any guarantee that of what will be available in the cache, or for how long.
We recommend following the latest version of the `jungle` flake to avoid cache
misses.

## Usage

### From NixOS

In NixOS, we can add the cache through the `nix.settings` option, which will
enable it for all builds in the system.

```nix
{ ... }: {
  nix.settings = {
    substituters = [ "https://jungle.bsc.es/cache" ];
    trusted-public-keys = [ "jungle.bsc.es:pEc7MlAT0HEwLQYPtpkPLwRsGf80ZI26aj29zMw/HH0=" ];
  };
}
```

### Interactively

The cache can also be specified in a per-command basis through the flags
`--substituters` and `--trusted-public-keys`:

```sh
nix build --substituters "https://jungle.bsc.es/cache" --trusted-public-keys "jungle.bsc.es:pEc7MlAT0HEwLQYPtpkPLwRsGf80ZI26aj29zMw/HH0=" <...>
```

Note: you'll have to be a trusted user.

### Nix configuration file (non-nixos)

If using nix outside of NixOS, you'll have to update `/etc/nix/nix.conf`

```
# echo "substituters = https://jungle.bsc.es/cache" >> /etc/nix/nix.conf
# echo "trusted-public-keys = jungle.bsc.es:pEc7MlAT0HEwLQYPtpkPLwRsGf80ZI26aj29zMw/HH0=" >> /etc/nix/nix.conf
```

### Hint in flakes

By adding the configuration below to a `flake.nix`, when someone uses the flake,
`nix` will interactively ask to trust and use the provided binary cache:

```nix
{
  nixConfig = {
    extra-substituters = [
      "https://jungle.bsc.es/cache"
    ];
    extra-trusted-public-keys = [
      "jungle.bsc.es:pEc7MlAT0HEwLQYPtpkPLwRsGf80ZI26aj29zMw/HH0="
    ];
  };
  outputs = { ... }: {
    ...
  };
}
```

### Querying the cache

Check if the cache is available:
```sh
$ curl https://jungle.bsc.es/cache/nix-cache-info
StoreDir: /nix/store
WantMassQuery: 1
Priority: 30
```

Prevent nix from building locally:
```bash
nix build --max-jobs 0 <...>
```

Check if a package is in cache:
```bash
# Do a raw eval on the <package>.outPath (this should not build the package)
$ nix eval --raw jungle#openmp.outPath
/nix/store/dwnn4dgm1m4184l4xbi0qfrprji9wjmi-openmp-2024.11
# Take the hash (everything from / to - in the basename) and curl <hash>.narinfo
# if it exists in the cache, it will return HTTP 200 and some information
# if not, it will return 404
$ curl https://jungle.bsc.es/cache/dwnn4dgm1m4184l4xbi0qfrprji9wjmi.narinfo
StorePath: /nix/store/dwnn4dgm1m4184l4xbi0qfrprji9wjmi-openmp-2024.11
URL: nar/dwnn4dgm1m4184l4xbi0qfrprji9wjmi-17imkdfqzmnb013d14dx234bx17bnvws8baf3ii1xra5qi2y1wiz.nar
Compression: none
NarHash: sha256:17imkdfqzmnb013d14dx234bx17bnvws8baf3ii1xra5qi2y1wiz
NarSize: 1519328
References: 4gk773fqcsv4fh2rfkhs9bgfih86fdq8-gcc-13.3.0-lib nqb2ns2d1lahnd5ncwmn6k84qfd7vx2k-glibc-2.40-36
Deriver: vcn0x8hikc4mvxdkvrdxp61bwa5r7lr6-openmp-2024.11.drv
Sig: jungle.bsc.es:GDTOUEs1jl91wpLbb+gcKsAZjpKdARO9j5IQqb3micBeqzX2M/NDtKvgCS1YyiudOUdcjwa3j+hyzV2njokcCA==
# In oneline:
$ curl "https://jungle.bsc.es/cache/$(nix eval --raw jungle#<package>.outPath | cut -d '/' -f4 | cut -d '-' -f1).narinfo"
```

#### References

- https://nix.dev/guides/recipes/add-binary-cache.html
- https://nixos.wiki/wiki/Binary_Cache
