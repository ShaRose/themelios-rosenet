{ config, pkgs, ... }:
{

# Arguments: ipaddr, qemuaddr (all the subnets etc can be calculated from it)

#sharoseadmin should have libvirt access
users.users.sharoseadmin.extraGroups = [ "libvirtd" ];

#packages
virtualisation.libvirtd.enable = true;
virtualisation.libvirtd.qemuPackage = pkgs.qemu_kvm;

# networking
networking.bridges.brqemu = { interfaces = []; };

networking.interfaces.brqemu = {
  ipv4 = {
    addresses = [ { address = "10.10.3.1"; prefixLength = 24; } ];
  };
  ipv6 = {
    addresses = [ { address = "2001:470:8c55:1003::1"; prefixLength = 64; } ];
  };
};

#add brqemu to quagga

services.quagga.ospf.config = ''network 10.10.3.0/24 area 0'';
services.quagga.ospf6.config = ''interface brqemu area 0.0.0.0'';

#dhcpv4

services.dhcpd4.enable = true;
services.dhcpd4.interfaces = [ "brqemu" ];
services.dhcpd4.extraConfig = ''
subnet 10.10.3.0 netmask 255.255.255.0 {
  range 10.10.3.200 10.10.3.254;
  option subnet-mask 255.255.255.0;
  option broadcast-address 10.10.3.255;
  option routers 10.10.3.1;
  option domain-name-servers 10.90.13.1, 10.90.13.3;
  option domain-name "local.rose.network";
}
'';

#radvd

services.radvd.enable = true;
services.radvd.config = ''
interface brqemu {
  AdvSendAdvert on;
  prefix 2001:470:8c55:1003::/64 { };
};
'';

}
