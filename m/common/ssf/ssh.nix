{
  # Use SSH tunnel to apex to reach internal hosts
  programs.ssh.extraConfig = ''
    Host tent
      ProxyJump raccoon

    # Access raccoon via the HTTP proxy
    Host raccoon knights3.bsc.es
      HostName knights3.bsc.es
      ProxyCommand=ssh apex 'nc -X connect -x localhost:23080 %h %p'

    # Make sure we can reach gitlab even if we don't have SSH access to raccoon
    Host bscpm04.bsc.es gitlab-internal.bsc.es
      ProxyCommand=ssh apex 'nc -X connect -x localhost:23080 %h %p'
  '';
}
