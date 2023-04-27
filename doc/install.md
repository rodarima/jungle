# Installing NixOS in a new node

This article shows the steps to install NixOS in a node following the
configuration of the repo.

## Prepare the disk

Create a main partition and label it `nixos` following [the manual][1].

[1]: https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual-partitioning.

```
# disk=/dev/sdX
# parted $disk -- mklabel msdos
# parted $disk -- mkpart primary 1MB 100%
# parted $disk -- set 1 boot on
```

Then create an etx4 filesystem, labeled `nixos` where the system will be
installed. **Ensure that no other partition has the same label.**

```
# mkfs.ext4 -L nixos "${disk}1"
# mount ${disk}1 /mnt
# lsblk -f $disk
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
sdX
`-sdX1 ext4   nixos 10d73b75-809c-4fa3-b99d-4fab2f0d0d8e /mnt
```

## Prepare nix and nixos-install

Mount the nix store from the xeon07 node in read-only /nix.

```
# mkdir /nix
# mount -o ro xeon07:/nix /nix
```

Get the nix binary and nixos-install tool from xeon07:

```
# ssh xeon07 'readlink -f $(which nix)'
/nix/store/0sxbaj71c4c4n43qhdxm31f56gjalksw-nix-2.13.3/bin/nix
# ssh xeon07 'readlink -f $(which nixos-install)'
/nix/store/9yq8ps06ysr2pfiwiij39ny56yk3pdcs-nixos-install/bin/nixos-install
```

And add them to the PATH:

```
# export PATH=$PATH:/nix/store/0sxbaj71c4c4n43qhdxm31f56gjalksw-nix-2.13.3/bin
# export PATH=$PATH:/nix/store/9yq8ps06ysr2pfiwiij39ny56yk3pdcs-nixos-install/bin/
# nix --version
nix (Nix) 2.13.3
```

## Build the nixos kexec image

```
# nix build .#nixosConfigurations.xeon02.config.system.build.kexecTree -v
```
