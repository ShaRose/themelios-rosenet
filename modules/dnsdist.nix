{ config, pkgs, ... }:
let
    dnsaddr = config.systeminfo.dnsAddr;
in
{

### Create interface

    networking.interfaces.dnsnic = {
        ipv4 = {
            addresses = [ { address = "${dnsaddr}"; prefixLength = 32; } ];
        };
        virtual = true;
    };

### Make sure it routes

    services.quagga.ospf.config = ''
        router ospf
            network ${ip4net}0/24 area 0
    '';

### Now enable dnsdist

    services.dnsdist.enable = true;
    services.dnsdist.listenAddress = "${dnsaddr}";
    services.dnsdist.extraConfig = ''
        newServer("8.8.8.8")
        newServer("8.8.4.4")
        newServer("1.1.1.1")
        newServer("1.0.0.1")

        newServer({address="10.1.0.130",  pool="rosenet"})
        newServer({address="10.10.3.130", pool="rosenet"})
        newServer({address="10.10.4.130", pool="rosenet"})

        addAction("local.rose.network", PoolAction("rosenet"))

        setServerPolicy(firstAvailable)

        setPoolServerPolicy(leastOutstanding, "rosenet")
    '';

}
