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

  # Authorize keys
  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBOf4r4lzQfyO0bx5BaREePREw8Zw5+xYgZhXwOZoBO ram@hop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINa0tvnNgwkc5xOwd6xTtaIdFi5jv0j2FrE7jl5MTLoE ram@mio"
    ];
    rarias.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBOf4r4lzQfyO0bx5BaREePREw8Zw5+xYgZhXwOZoBO ram@hop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINa0tvnNgwkc5xOwd6xTtaIdFi5jv0j2FrE7jl5MTLoE ram@mio"
    ];
  };

  programs.ssh.knownHosts = {
    "gitlab-internal.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9arsAOSRB06hdy71oTvJHG2Mg8zfebADxpvc37lZo3";
    "bscpm03.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2NuSUPsEhqz1j5b4Gqd+MWFnRqyqY57+xMvBUqHYUS";
  };
}
