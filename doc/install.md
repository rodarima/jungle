# Installing NixOS in a new node

This article shows the steps to install NixOS in a node following the
configuration of the repo.

## Enable the serial console

By default, the nodes have the serial console disabled in the GRUB and also boot
without the serial enabled.

To enable the serial console in the GRUB, set in /etc/default/grub the following
lines:

```
GRUB_TERMINAL="console serial"
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
```

To boot Linux with the serial enabled, so you can see the boot log and login via
serial set:

```
GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0"
```

Then update the grub config:

```
# grub2-mkconfig -o /boot/grub2/grub.cfg
```

And reboot.

## Prepare the disk

Create a main partition and label it `nixos` following [the manual][1].

[1]: https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual-partitioning.

```
# disk=/dev/sdX
# parted $disk -- mklabel msdos
# parted $disk -- mkpart primary 1MB -8GB
# parted $disk -- mkpart primary linux-swap -8GB 100%
# parted $disk -- set 1 boot on
```

Then create an etx4 filesystem, labeled `nixos` where the system will be
installed. **Ensure that no other partition has the same label.**

```
# mkfs.ext4 -L nixos "${disk}1"
# mkswap -L swap "${disk}2"
# mount ${disk}1 /mnt
# lsblk -f $disk
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
sdX
`-sdX1 ext4   nixos 10d73b75-809c-4fa3-b99d-4fab2f0d0d8e /mnt
```

## Prepare nix and nixos-install

Mount the nix store from the hut node in read-only /nix.

```
# mkdir /nix
# mount -o ro hut:/nix /nix
```

Get the nix binary and nixos-install tool from hut:

```
# ssh hut 'readlink -f $(which nix)'
/nix/store/0sxbaj71c4c4n43qhdxm31f56gjalksw-nix-2.13.3/bin/nix
# ssh hut 'readlink -f $(which nixos-install)'
/nix/store/9yq8ps06ysr2pfiwiij39ny56yk3pdcs-nixos-install/bin/nixos-install
```

And add them to the PATH:

```
# export PATH=$PATH:/nix/store/0sxbaj71c4c4n43qhdxm31f56gjalksw-nix-2.13.3/bin
# export PATH=$PATH:/nix/store/9yq8ps06ysr2pfiwiij39ny56yk3pdcs-nixos-install/bin/
# nix --version
nix (Nix) 2.13.3
```

## Adapt owl configuration

Clone owl repo:

```
$ git clone git@bscpm03.bsc.es:rarias/owl.git
$ cd owl
```

Edit the configuration to your needs.

## Install from another Linux OS

Install nixOS into the storage drive.

```
# nixos-install --flake --root /mnt .#xeon0X
```

At this point, the nixOS grub has been installed into the nixos device, which
is not the default boot device. To keep both the old Linux and NixOS grubs, add
an entry into the old Linux grub to jump into the new grub.

```
# echo "

menuentry 'NixOS' {
    insmod chain
    search --no-floppy --label nixos --set root
    configfile /boot/grub/grub.cfg
} " >> /etc/grub.d/40_custom
```

Rebuild grub config.

```
# grub2-mkconfig -o /boot/grub/grub.cfg
```

To boot into NixOS manually, reboot and select NixOS in the grub menu to boot
into NixOS.

To temporarily boot into NixOS only on the next reboot run:

```
# grub2-reboot 'NixOS'
```

To permanently boot into NixOS as the default boot OS, edit `/etc/default/grub/`:

```
GRUB_DEFAULT='NixOS'
```

And update grub.

```
# grub2-mkconfig -o /boot/grub/grub.cfg
```

## Build the nixos kexec image

```
# nix build .#nixosConfigurations.xeon02.config.system.build.kexecTree -v
```

## Chain NixOS in same disk

```
menuentry 'NixOS' {
        insmod chain
        set root=(hd3,1)
        configfile /boot/grub/grub.cfg
}
```
