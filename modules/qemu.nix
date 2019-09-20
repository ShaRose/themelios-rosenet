{ config, pkgs, ... }:
{

# Arguments: qemuaddr (all the subnets etc can be calculated from it)

#sharoseadmin should have libvirt access
users.users.sharoseadmin.extraGroups = [ "libvirtd" ];

#packages
virtualisation.libvirtd.enable = true;
virtualisation.libvirtd.qemuPackage = pkgs.qemu_kvm;

# Filesystem configuration

systemd.services.qemu_verifyzfs = {
    before = [ "libvirtd" ];
    description = "creates qemu zfs filesystems";
    script = ''
zfs create -p -o mountpoint=/atlas-qemu atlas-pool/qemu
'';
};

systemd.services.qemu_verifystorage = {
    after = [ "libvirtd" ];
    description = "creates qemu zfs pool";
    script = ''
if ( virsh pool-dumpxml default 2>/dev/null | grep -q "/atlas-qemu" )
    virsh pool-delete default
    virsh pool-undefine default
    virsh pool-define-as --name default --type dir --target /atlas-qemu
    virsh pool-autostart default
    virsh pool-start default
fi
'';
};

systemd.services.qemu_verifynetwork = {
    after = [ "libvirtd" ];
    description = "creates brqemu bridge";
    script = ''
if ( virsh net-info qemunet 2>/dev/null )
    xmlpath=$(mktemp)
    cat << 'EOF' > $xmlpath
<network connections='1'>
  <name>qemunet</name>
  <forward mode='route'/>
  <bridge name='brqemu' macTableManager='libvirt'/>
  <ip address='10.10.3.1' netmask='255.255.255.0'/>
  <ip family='ipv6' address='2001:470:8c55:1003::1' prefix='64'/>
</network>
EOF
    virsh net-define $xmlpath
    rm $xmlpath
    virsh net-autostart qemunet
    virsh net-start qemunet
fi
'';
};

#add brqemu to quagga

services.quagga.ospf.config = ''
router ospf
  network 10.10.3.0/24 area 0
'';
services.quagga.ospf6.config = ''
router ospf6
  interface brqemu area 0.0.0.0
'';

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
