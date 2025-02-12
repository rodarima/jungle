---
title: "Fox"
description: "AMD Genoa 9684X with 2 NVIDIA RTX4000 GPUs"
date: 2025-02-12
---

![Fox](fox.jpg)

Picture by [Joanne Redwood](https://web.archive.org/web/20191109175146/https://www.inaturalist.org/photos/6568074),
[CC0](http://creativecommons.org/publicdomain/zero/1.0/deed.en).

The *fox* machine is a big GPU server that is configured to run heavy workloads.
It has two fast AMD CPUs with large cache and 2 reasonable NVIDIA GPUs. Here are
the detailed specifications:

- 2x AMD GENOA X 9684X DP/UP 96C/192T 2.55G 1,150M 400W SP5 3D V-cach
- 24x 32GB DDR5-4800 ECC RDIMM (total 768 GiB of RAM)
- 1x 2.5" SSD SATA3 MICRON 5400 MAX 480GB
- 2x 2.5" KIOXIA CM7-R 1.92TB NVMe GEN5 PCIe 5x4
- 2x NVIDIA RTX4000 ADA Gen 20GB GDDR6 PCIe 4.0

## Access

To access the machine, request a SLURM session from [hut](/hut) using the `fox`
partition:

    hut% salloc -p fox

Then connect via ssh:

    hut% ssh fox
    fox%

Follow [these steps](/access) if you don't have access to hut or fox.

## CUDA

To use CUDA, you can use the following `flake.nix` placed in a new directory to
load all the required dependencies:

```nix
{
  inputs.jungle.url = "jungle";

  outputs = { jungle, ... }: {
    devShell.x86_64-linux = let
      pkgs = jungle.nixosConfigurations.fox.pkgs;
    in pkgs.mkShell {
      name = "cuda-env-shell";
      buildInputs = with pkgs; [
        git gitRepo gnupg autoconf curl
        procps gnumake util-linux m4 gperf unzip

        # Cuda packages (more at https://search.nixos.org/packages)
        cudatoolkit linuxPackages.nvidia_x11
        cudaPackages.cuda_cudart.static
        cudaPackages.libcusparse

        libGLU libGL
        xorg.libXi xorg.libXmu freeglut
        xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
        ncurses5 stdenv.cc binutils
      ];
      shellHook = ''
        export CUDA_PATH=${pkgs.cudatoolkit}
        export LD_LIBRARY_PATH=/var/run/opengl-driver/lib
        export SMS=50
      '';
    };
  };
}
```

Then just run `nix develop` from the same directory:

    % mkdir cuda
    % cd cuda
    % vim flake.nix
    [...]
    % nix develop
    $ nvcc -V
    nvcc: NVIDIA (R) Cuda compiler driver
    Copyright (c) 2005-2024 NVIDIA Corporation
    Built on Tue_Feb_27_16:19:38_PST_2024
    Cuda compilation tools, release 12.4, V12.4.99
    Build cuda_12.4.r12.4/compiler.33961263_0

## Filesystems

The machine has several file systems available.

- `$HOME`: Mounted via NFS across all nodes. It is slow and has low capacity.
  Don't abuse.
- `/ceph/home/$USER`: Shared Ceph file system across jungle nodes. Slow but high
  capacity. Stores three redundant copies of every file.
- `/nvme{0,1}/$USER`: The two local NVME disks, very fast and large capacity.
- `/tmp`: tmpfs, fast but not backed by a disk. Will be erased on reboot.
