{ config, pkgs, lib, ... }:
let
    dnsaddr = config.systeminfo.dnsAddr;
in
{

    require = [
        ./quagga.nix
    ];

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
            passive-interface dnsnic
    '';

### Now make sure it routes even if it's 'down'.

    services.quagga.zebra.config = ''
        interface dnsnic
            no link-detect
    '';

### Firewall rules

    networking.firewall.extraCommands = ''
        iptables -A INPUT -p udp -m udp --dport 53 -d ${dnsaddr} -j ACCEPT
        iptables -A INPUT -p tcp -m tcp --dport 53 -d ${dnsaddr} -j ACCEPT
    '';

### Now enable dnsdist

    services.dnsdist.enable = true;
    systemd.services.dnsdist.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    systemd.services.dnsdist.serviceConfig.CapabilityBoundingSet = lib.mkForce "CAP_NET_BIND_SERVICE";
    services.dnsdist.listenAddress = "${dnsaddr}";
    services.dnsdist.extraConfig = ''
        newServer({ address="8.8.8.8", maxCheckFailures=4 })
        newServer({ address="8.8.4.4", maxCheckFailures=4 })
        newServer({ address="1.1.1.1", maxCheckFailures=4 })
        newServer({ address="1.0.0.1", maxCheckFailures=4 })

        pc = newPacketCache(10000)
        getPool(""):setCache(pc)

        newServer({address="10.1.0.130",  pool="rosenet"})
        newServer({address="10.10.3.130", pool="rosenet"})
        newServer({address="10.10.4.130", pool="rosenet"})

        addAction("local.rose.network", PoolAction("rosenet"))

        setServerPolicy(leastOutstanding)

        setPoolServerPolicy(leastOutstanding, "rosenet")
    '';
    
    
}

