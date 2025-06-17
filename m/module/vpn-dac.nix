{config, ...}:
{
  age.secrets.vpn-dac-login.file = ../../secrets/vpn-dac-login.age;
  age.secrets.vpn-dac-client-key.file = ../../secrets/vpn-dac-client-key.age;

  services.openvpn.servers = {
    # systemctl status openvpn-dac.service
    dac = {
      config = ''
        client
        dev tun
        proto tcp
        remote vpn.ac.upc.edu 1194
        remote vpn.ac.upc.edu 80
        resolv-retry infinite
        nobind
        persist-key
        persist-tun
        ca ${./vpn-dac/ca.crt}
        cert ${./vpn-dac/client.crt}
        # Only key needs to be secret
        key ${config.age.secrets.vpn-dac-client-key.path}
        remote-cert-tls server
        comp-lzo
        verb 3
        auth-user-pass ${config.age.secrets.vpn-dac-login.path}
        reneg-sec 0

	# Ignore 10.0.0.0 route as is not needed
        pull-filter ignore "route 10.0.0.0"
      '';
    };
  };
}
