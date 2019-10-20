{ config, pkgs, ... }:
let
    dnsaddr = config.systeminfo.dnsAddr;
in
{

### Create interface

    networking.bridges.dnsnic = {
        interfaces = [];
    };

    networking.interfaces.dnsnic = {
        ipv4 = {
            addresses = [ { address = "${dnsaddr}"; prefixLength = 32; } ];
        };
    };

### Make sure it routes

    services.quagga.ospf.config = ''
        router ospf
            network ${dnsaddr}/32 area 0
    '';

### Firewall rules

    networking.firewall.extraCommands = ''
        iptables -A INPUT -p udp -m udp --dport 53 -d ${dnsaddr} -j ACCEPT
        iptables -A INPUT -p tcp -m tcp --dport 53 -d ${dnsaddr} -j ACCEPT
    '';

### Now enable dnsdist

    services.dnsdist.enable = true;
    services.dnsdist.listenAddress = "${dnsaddr}";
    services.dnsdist.extraConfig = ''
        newServer("8.8.8.8")
        newServer("8.8.4.4")
        newServer("1.1.1.1")
        newServer("1.0.0.1")

        pc = newPacketCache(10000, {maxTTL=86400, minTTL=0, temporaryFailureTTL=60, staleTTL=60, dontAge=false})
        getPool(""):setCache(pc)

        newServer({address="10.1.0.130",  pool="rosenet"})
        newServer({address="10.10.3.130", pool="rosenet"})
        newServer({address="10.10.4.130", pool="rosenet"})

        addAction("local.rose.network", PoolAction("rosenet"))

        setServerPolicy(firstAvailable)

        setPoolServerPolicy(leastOutstanding, "rosenet")
    '';

}

