{ pkgs, ... }:

{
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

      rpenacob = {
        uid = 2761;
        isNormalUser = true;
        home = "/home/Computational/rpenacob";
        description = "Raúl Peñacoba";
        group = "Computational";
        hashedPassword = "$6$TZm3bDIFyPrMhj1E$uEDXoYYd1z2Wd5mMPfh3DZAjP7ztVjJ4ezIcn82C0ImqafPA.AnTmcVftHEzLB3tbe2O4SxDyPSDEQgJ4GOtj/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYfXg37mauGeurqsLpedgA2XQ9d4Nm0ZGo/hI1f7wwH rpenacob@bsc"
        ];
      };
    };

    groups = {
      Computational = { gid = 564; };
    };
  };
}
