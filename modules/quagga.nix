{ config, pkgs, ... }:
let
    ipaddr = config.systeminfo.ipAddr;
    nicname = config.systeminfo.nicName;
    
    ipnet = builtins.elemAt (builtins.match "(10\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.)[[:digit:]]{1,3}" ipaddr) 0;
in
{

    services.quagga.ospf = {
        enable = true;
        config = ''
            router ospf
                network ${ipnet}0/24 area 0
        '';
    };

    services.quagga.ospf6 = {
        enable = true;
        config = ''
            router ospf6
                interface ${nicname} area 0.0.0.0
        '';
    };

    services.quagga.zebra.enable = true;
    services.quagga.zebra.config = ''
        router-id ${ipaddr}
    '';

    networking.firewall.extraCommands = ''
        iptables -A INPUT -i ${nicname} -p ospfigp -j ACCEPT
        ip6tables -A INPUT -i ${nicname} -p ospfigp -j ACCEPT
    '';

    environment.variables.VTYSH_PAGER = "more";

}
