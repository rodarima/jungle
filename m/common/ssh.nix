{ ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Connect to intranet git hosts via proxy
  programs.ssh.extraConfig = ''
    Host bscpm02.bsc.es bscpm03.bsc.es gitlab-internal.bsc.es alya.gitlab.bsc.es
      User git
      ProxyCommand nc -X connect -x localhost:23080 %h %p
  '';

  programs.ssh.knownHosts = {
    "hut".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICO7jIp6JRnRWTMDsTB/aiaICJCl4x8qmKMPSs4lCqP1";
    "owl1".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqMEXO0ApVsBA6yjmb0xP2kWyoPDIWxBB0Q3+QbHVhv";
    "owl2".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHurEYpQzNHqWYF6B9Pd7W8UPgF3BxEg0BvSbsA7BAdK";
    "eudy".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+WYPRRvZupqLAG0USKmd/juEPmisyyJaP8hAgYwXsG";

    "gitlab-internal.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9arsAOSRB06hdy71oTvJHG2Mg8zfebADxpvc37lZo3";
    "bscpm03.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2NuSUPsEhqz1j5b4Gqd+MWFnRqyqY57+xMvBUqHYUS";
  };
}
