{
  programs.ssh.extraConfig = ''
    Host ssfhead
      HostName ssflogin.bsc.es
    Host hut
      ProxyJump ssfhead
      HostName xeon07
  '';
}
