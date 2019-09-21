{ config, pkgs, ... }:
let
    ipddr = "10.10.3.1";
    nicname = "mlxnic";
in
{

services.quagga.ospf = {
    enable = true;
    config = ''
router ospf
  network 10.90.10.0/24 area 0
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
services.quagga.zebra.config = ''router-id ${ipddr}'';

networking.firewall.extraCommands = ''
iptables -A INPUT -i ${nicname} -p ospfigp -j ACCEPT
ip6tables -A INPUT -i ${nicname} -p ospfigp -j ACCEPT
'';

environment.variables.VTYSH_PAGER = "more";

}
