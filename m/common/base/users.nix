{ pkgs, ... }:

{
  imports = [
    ../../module/jungle-users.nix
  ];

  users = {
    mutableUsers = false;
    users = {
      # Generate hashedPassword with `mkpasswd -m sha-512`

      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBOf4r4lzQfyO0bx5BaREePREw8Zw5+xYgZhXwOZoBO ram@hop"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINa0tvnNgwkc5xOwd6xTtaIdFi5jv0j2FrE7jl5MTLoE ram@mio"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3zeB5KSimMBAjvzsp1GCkepVaquVZGPYwRIzyzaCba aleix@bsc"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIII/1TNArcwA6D47mgW4TArwlxQRpwmIGiZDysah40Gb root@hut"
      ];

      rarias = {
        uid = 1880;
        isNormalUser = true;
        home = "/home/Computational/rarias";
        description = "Rodrigo Arias";
        group = "Computational";
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$u06tkCy13enReBsb$xiI.twRvvTfH4jdS3s68NZ7U9PSbGKs5.LXU/UgoawSwNWhZo2hRAjNL5qG0/lAckzcho2LjD0r3NfVPvthY6/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBOf4r4lzQfyO0bx5BaREePREw8Zw5+xYgZhXwOZoBO ram@hop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINa0tvnNgwkc5xOwd6xTtaIdFi5jv0j2FrE7jl5MTLoE ram@mio"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYcXIxe0poOEGLpk8NjiRozls7fMRX0N3j3Ar94U+Gl rarias@hal"
        ];
        shell = pkgs.zsh;
      };

      arocanon = {
        uid = 1042;
        isNormalUser = true;
        home = "/home/Computational/arocanon";
        description = "Aleix Roca";
        group = "Computational";
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$hliZiW4tULC/tH7p$pqZarwJkNZ7vS0G5llWQKx08UFG9DxDYgad7jplMD8WkZh5k58i4dfPoWtnEShfjTO6JHiIin05ny5lmSXzGM/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3zeB5KSimMBAjvzsp1GCkepVaquVZGPYwRIzyzaCba aleix@bsc"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGdphWxLAEekicZ/WBrvP7phMyxKSSuLAZBovNX+hZXQ aleix@kerneland"
        ];
      };
    };

    jungleUsers = {
      rpenacob = {
        uid = 2761;
        isNormalUser = true;
        home = "/home/Computational/rpenacob";
        description = "Raúl Peñacoba";
        group = "Computational";
        hosts = [ "owl1" "owl2" "hut" ];
        hashedPassword = "$6$TZm3bDIFyPrMhj1E$uEDXoYYd1z2Wd5mMPfh3DZAjP7ztVjJ4ezIcn82C0ImqafPA.AnTmcVftHEzLB3tbe2O4SxDyPSDEQgJ4GOtj/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYfXg37mauGeurqsLpedgA2XQ9d4Nm0ZGo/hI1f7wwH rpenacob@bsc"
        ];
      };

      anavarro = {
        uid = 1037;
        isNormalUser = true;
        home = "/home/Computational/anavarro";
        description = "Antoni Navarro";
        group = "Computational";
        hosts = [ "hut" "raccoon" ];
        hashedPassword = "$6$QdNDsuLehoZTYZlb$CDhCouYDPrhoiB7/seu7RF.Gqg4zMQz0n5sA4U1KDgHaZOxy2as9pbIGeF8tOHJKRoZajk5GiaZv0rZMn7Oq31";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWjRSlKgzBPZQhIeEtk6Lvws2XNcYwHcwPv4osSgst5 anavarro@ssfhead"
        ];
      };

      abonerib = {
        uid = 4541;
        isNormalUser = true;
        home = "/home/Computational/abonerib";
        description = "Aleix Boné";
        group = "Computational";
        hosts = [ "owl1" "owl2" "hut" "raccoon" ];
        hashedPassword = "$6$V1EQWJr474whv7XJ$OfJ0wueM2l.dgiJiiah0Tip9ITcJ7S7qDvtSycsiQ43QBFyP4lU0e0HaXWps85nqB4TypttYR4hNLoz3bz662/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIFiqXqt88VuUfyANkZyLJNiuroIITaGlOOTMhVDKjf abonerib@bsc"
        ];
      };

      vlopez = {
        uid = 4334;
        isNormalUser = true;
        home = "/home/Computational/vlopez";
        description = "Victor López";
        group = "Computational";
        hosts = [ "koro" ];
        hashedPassword = "$6$0ZBkgIYE/renVqtt$1uWlJsb0FEezRVNoETTzZMx4X2SvWiOsKvi0ppWCRqI66S6TqMBXBdP4fcQyvRRBt0e4Z7opZIvvITBsEtO0f0";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMwlUZRf9jfG666Qa5Sb+KtEhXqkiMlBV2su3x/dXHq victor@arch"
        ];
      };

      dbautist = {
        uid = 5649;
        isNormalUser = true;
        home = "/home/Computational/dbautist";
        description = "Dylan Bautista Cases";
        group = "Computational";
        hosts = [ "hut" ];
        hashedPassword = "$6$a2lpzMRVkG9nSgIm$12G6.ka0sFX1YimqJkBAjbvhRKZ.Hl090B27pdbnQOW0wzyxVWySWhyDDCILjQELky.HKYl9gqOeVXW49nW7q/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAb+EQBoS98zrCwnGKkHKwMLdYABMTqv7q9E0+T0QmkS dbautist@bsc-848818791"
        ];
      };

      dalvare1 = {
        uid = 2758;
        isNormalUser = true;
        home = "/home/Computational/dalvare1";
        description = "David Álvarez";
        group = "Computational";
        hosts = [ "hut" ];
        hashedPassword = "$6$mpyIsV3mdq.rK8$FvfZdRH5OcEkUt5PnIUijWyUYZvB1SgeqxpJ2p91TTe.3eQIDTcLEQ5rxeg.e5IEXAZHHQ/aMsR5kPEujEghx0";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEfy6F4rF80r4Cpo2H5xaWqhuUZzUsVsILSKGJzt5jF dalvare1@ssfhead"
        ];
      };
    };

    groups = {
      Computational = { gid = 564; };
    };
  };
}
