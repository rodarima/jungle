{ theFlake, pkgs, ... }:

# This module describes a script that can launch the pixiecore daemon to serve a
# NixOS image via PXE to a node to directly boot from there, without requiring a
# working disk.

let
  # The host config must have the netboot-minimal.nix module too
  host = theFlake.nixosConfigurations.lake2;
  sys = host.config.system;
  build = sys.build;
  kernel = "${build.kernel}/bzImage";
  initrd = "${build.netbootRamdisk}/initrd";
  init = "${build.toplevel}/init";

  script = pkgs.writeShellScriptBin "pixiecore-helper" ''
    #!/usr/bin/env bash -x

    ${pkgs.pixiecore}/bin/pixiecore \
      boot ${kernel} ${initrd} --cmdline "init=${init} loglevel=4" \
      --debug --dhcp-no-bind --port 64172 --status-port 64172 "$@"
  '';
in
{
  ## We need a DHCP server to provide the IP
  #services.dnsmasq = {
  #  enable = true;
  #  settings = {
  #    domain-needed = true;
  #    dhcp-range = [ "192.168.0.2,192.168.0.254" ];
  #  };
  #};

  environment.systemPackages = [ script ];
}
