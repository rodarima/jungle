---
title: "Quick start"
date: 2023-09-15
---

This documentation will guide you on how to build custom packages of software
and use them in the jungle machines. It has been designed to reduce the friction
from users coming from module systems.

You should be able to access the jungle machines, otherwise [request
access](/access).

## Changes from other HPC machines

Users of other machines have been using the Lmod tool (module load ...) to add
or remove programs from their environment, as well as manually building their
own software for too many years.

While we cannot prevent users from continuing to use this tedious mechanism, we
have designed the jungle machines to be much easier to operate by using the nix
package manager.

### Freedom to install packages

When a user wanted to install a package, it was forced to either do it on its
own directory, or request a system administrator to install it in a shared
directory, so other users can also use that package.

This situation is gone, each user can install any package of software by
themselves, without requiring any other authorization. When two users request
the same package, the same copy will be provided.

A new package will be downloaded if it is available (someone already built it)
or will be built from source on demand.

### No changes over time

All users retain the same versions of the packages they request until they
decide to update them.

## Using nix to manage packages

In this chapter we show how to install packages and enter a development shell to
build new programs from source. The examples are done from the hut machine,
read [this page](/access) to request access.

### Installing binaries

To temporarily install new packages, use:

```text
hut% nix shell jungle#gcc jungle#cowsay jungle#ovni
```

Notice that the packages are described as two parts divided by the `#` symbol.
The first part defines where to take the package from and the second part is
the name of the package. For now we will use `jungle#<package>`. You can find
many more packages here:

<https://search.nixos.org/packages>

You will now enter a new shell, where those requested package **binaries are
available in $PATH**:

```text
hut% cowsay hello world
 _____________
< hello world >
 -------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

hut% ovniver
LD_LIBRARY_PATH not set
libovni: build v1.11.0 (a7103f8), dynamic v1.11.0 (a7103f8)

hut% gcc --version
gcc (GCC) 13.3.0
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

### Building programs

The above method only loads new binaries in the `$PATH`. If we try to build a
program that includes headers or links with a library, it will fail to find
them:

```text
hut$ cat test.c
#include <ovni.h>

int main()
{
        ovni_version_check();
        return 0;
}
hut% gcc test.c -lovni -o test
test.c:1:10: fatal error: ovni.h: No such file or directory
    1 | #include <ovni.h>
      |          ^~~~~~~~
compilation terminated.
```

We could manually add the full path to the ovni include directory with `-I` and
the libraries with `-L`, but there is a tool that already perform these steps
automatically for us, `nix develop`.

Let's go back to our original shell first, where those packages are not
available anymore:

```
hut% ps
    PID TTY          TIME CMD
2356260 pts/1    00:00:01 zsh
2457268 pts/1    00:00:00 zsh
2457297 pts/1    00:00:00 ps
hut% exit
hut% ovniver
ovniver: command not found
```

### Creating a flake.nix

To define which packages we want, we will write a small file that list them, a
flake.nix file.

First, we will create a new directory where we are going to be working:

```
hut% mkdir example
hut% cd exmple
```

Then place this flake.nix file:

```nix
{
  inputs.jungle.url = "jungle";
  outputs = { self, jungle }:  
  let
    pkgs = jungle.outputs.packages.x86_64-linux;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      pname = "devshell";
      buildInputs = with pkgs; [
        ovni gcc cowsay # more packages here...
      ];
    };
  };
}
```


Now enter the shell with:

```
hut% nix develop
warning: creating lock file '/home/Computational/rarias/example/flake.lock':
• Added input 'jungle':
    'path:/nix/store/27srv8haj6vv4ywrbmw0a8vds561m8rq-source?lastModified=1739479441&narHash=sha256-Kgjs8SO1w9NbPBu8ghwzCxYJ9kvWpoQOT%2BXwPvA9DcU%3D&rev=76396c0d67ef0cf32377d5c1894bb695293bca9d' (2025-02-13)
• Added input 'jungle/agenix':
    'github:ryantm/agenix/f6291c5935fdc4e0bef208cfc0dcab7e3f7a1c41?narHash=sha256-b%2Buqzj%2BWa6xgMS9aNbX4I%2BsXeb5biPDi39VgvSFqFvU%3D' (2024-08-10)
• Added input 'jungle/agenix/darwin':
    'github:lnl7/nix-darwin/4b9b83d5a92e8c1fbfd8eb27eda375908c11ec4d?narHash=sha256-gzGLZSiOhf155FW7262kdHo2YDeugp3VuIFb4/GGng0%3D' (2023-11-24)
• Added input 'jungle/agenix/darwin/nixpkgs':
    follows 'jungle/agenix/nixpkgs'
• Added input 'jungle/agenix/home-manager':
    'github:nix-community/home-manager/3bfaacf46133c037bb356193bd2f1765d9dc82c1?narHash=sha256-7ulcXOk63TIT2lVDSExj7XzFx09LpdSAPtvgtM7yQPE%3D' (2023-12-20)
• Added input 'jungle/agenix/home-manager/nixpkgs':
    follows 'jungle/agenix/nixpkgs'
• Added input 'jungle/agenix/nixpkgs':
    follows 'jungle/nixpkgs'
• Added input 'jungle/agenix/systems':
    'github:nix-systems/default/da67096a3b9bf56a91d16901293e51ba5b49a27e?narHash=sha256-Vy1rq5AaRuLzOxct8nz4T6wlgyUR7zLU309k9mBC768%3D' (2023-04-09)
• Added input 'jungle/bscpkgs':
    'git+https://git.sr.ht/~rodarima/bscpkgs?ref=refs/heads/master&rev=6782fc6c5b5a29e84a7f2c2d1064f4bcb1288c0f' (2024-11-29)
• Added input 'jungle/bscpkgs/nixpkgs':
    follows 'jungle/nixpkgs'
• Added input 'jungle/nixpkgs':
    'github:NixOS/nixpkgs/9c6b49aeac36e2ed73a8c472f1546f6d9cf1addc?narHash=sha256-i/UJ5I7HoqmFMwZEH6vAvBxOrjjOJNU739lnZnhUln8%3D' (2025-01-14)

hut$ 
```

Notice that long list of messages is Nix creating a new flake.lock file with the
current state of the packages. Next invocations will use the same packages as
described by the lock file.

### Building a program from nix develop

Now let's try again building our test program:

```text
hut$ cat test.c
#include <ovni.h>

int main()
{
        ovni_version_check();
        return 0;
}
hut$ gcc test.c -o test -lovni
hut$ ldd test
        linux-vdso.so.1 (0x00007ffff7fc4000)
        libovni.so.1 => /nix/store/sqk972akjv0q8dchn8ccjln2llzyyfd0-ovni-1.11.0/lib/libovni.so.1 (0x00007ffff7fab000)
        libc.so.6 => /nix/store/nqb2ns2d1lahnd5ncwmn6k84qfd7vx2k-glibc-2.40-36/lib/libc.so.6 (0x00007ffff7db2000)
        /nix/store/nqb2ns2d1lahnd5ncwmn6k84qfd7vx2k-glibc-2.40-36/lib/ld-linux-x86-64.so.2 => /nix/store/nqb2ns2d1lahnd5ncwmn6k84qfd7vx2k-glibc-2.40-36/lib64/ld-linux-x86-64.so.2 (0x00007ffff7fc6000)
hut$ ./test
```

Now the ovni.h header and the libovni library are found and the program is
successfully built, linked and executed.

You can add more packages as needed in your flake.nix:

```nix
  buildInputs = with pkgs; [
    ovni gcc cowsay # more packages here...
  ];
```

Make sure you exit the develop shell first, and then enter again with `nix
develop`.

## Remember

- `nix shell` places binaries in the `$PATH`.
- `nix develop` enters a development shell where both binaries and the libraries
  and includes are available so you can build new programs.
