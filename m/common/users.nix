{ ... }:

{
  users = {
    mutableUsers = false;
    users = {
      rarias = {
        uid = 1880;
        isNormalUser = true;
        home = "/home/Computational/rarias";
        description = "Rodrigo Arias";
        group = "Computational";
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$u06tkCy13enReBsb$xiI.twRvvTfH4jdS3s68NZ7U9PSbGKs5.LXU/UgoawSwNWhZo2hRAjNL5qG0/lAckzcho2LjD0r3NfVPvthY6/";
      };

      arocanon = {
        uid = 1042;
        isNormalUser = true;
        home = "/home/Computational/arocanon";
        description = "Aleix Roca";
        group = "Computational";
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$hliZiW4tULC/tH7p$pqZarwJkNZ7vS0G5llWQKx08UFG9DxDYgad7jplMD8WkZh5k58i4dfPoWtnEShfjTO6JHiIin05ny5lmSXzGM/";
      };

      rpenacob = {
        uid = 2761;
        isNormalUser = true;
        home = "/home/Computational/rpenacob";
        description = "Raúl Penacoba";
        group = "Computational";
        hashedPassword = "$6$TZm3bDIFyPrMhj1E$uEDXoYYd1z2Wd5mMPfh3DZAjP7ztVjJ4ezIcn82C0ImqafPA.AnTmcVftHEzLB3tbe2O4SxDyPSDEQgJ4GOtj/";
      };
    };

    groups = {
      Computational = { gid = 564; };
    };
  };
}
