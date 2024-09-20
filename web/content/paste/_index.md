---
title: "Paste"
description: "Paste service"
author: "Rodrigo Arias Mallo"
date: 2024-09-20
---

The hut machine provides a paste service using the program `p` (as in paste).

You can use it directly from the hut machine or remotely if you have [SSH
access](/access) to hut using the following alias:

```
alias p="ssh hut p"
```

You can add it to bashrc or zshrc for persistent installation.

## Usage

The `p` command reads from the standard input, uploads the content to a file
in the ceph filesystem and prints the URL to access it. It only accepts an
optional argument, which is the extension of the file that will be stored on
disk (without the dot). By default it uses the `txt` extension, so plain text
can be read in the browser directly.

```
p [extension]
```

To remove files, go to `/ceph/p/$USER` and remove them manually.

## Examples

Share a text file, in this case the source of p itself:

```
hut% p < m/hut/p.nix
https://jungle.bsc.es/p/rarias/okbtG130.txt
```

Paste the last dmesg lines directly from a pipe:

```
hut% dmesg | tail -5 | p
https://jungle.bsc.es/p/rarias/luX4STm9.txt
```

Upload a PNG picture from a file:

```
hop% p png < mark-api-cpu.png
https://jungle.bsc.es/p/rarias/oSRAMVsE.png
```

Take an screenshot and upload it as a PNG file:

```
hop% scrot -s - | p png
https://jungle.bsc.es/p/rarias/SOgK5EV0.png
```

Upload a directory by creating a tar.gz file on the fly:

```
hop% tar c ovni | gzip | p tar.gz
https://jungle.bsc.es/p/rarias/tkwROcTR.tar.gz
```
