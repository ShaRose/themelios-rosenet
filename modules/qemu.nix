{ config, pkgs, ... }:
let
    qemuaddr = config.systeminfo.qemuAddr;
    hostname = config.systeminfo.hostname;

    parts = builtins.match "10\.([[:digit:]]{1,2})\.([[:digit:]]{1,2})\.1" qemuaddr;

    mainnet = builtins.elemAt parts 0;
    subnet = builtins.elemAt parts 1;
    psubnet = if (builtins.stringLength subnet) == 1 then ("0" + subnet) else (subnet);

    ip4net = "10.${mainnet}.${subnet}.";
    ip6net = "2001:470:8c55:${mainnet}${psubnet}::";
in
{

    users.users.sharoseadmin.extraGroups = [ "libvirtd" ];

    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemuPackage = pkgs.qemu_kvm;
    environment.systemPackages = [ pkgs.OVMF ];

### Filesystem configuration

    systemd.services.qemu_verifyzfs = {
        before = [ "libvirtd.service" ];
        path = [ pkgs.zfs ];
        wantedBy = [ "multi-user.target" ];
        description = "creates qemu zfs filesystems";
        script = ''
            zfs create -p -o mountpoint=/${hostname}-qemu ${hostname}-pool/qemu
        '';
    };

    systemd.services.qemu_verifystorage = {
        after = [ "libvirtd.service" ];
        description = "creates qemu zfs pool";
        path = [ pkgs.libvirt ];
        wantedBy = [ "multi-user.target" ];
        script = ''
            if ( ! virsh pool-dumpxml default 2>/dev/null | grep -q "/${hostname}-qemu" ); then
                if ( virsh pool-list | grep -q default ); then
                    echo "Destroying default pool..."
                    virsh pool-delete default
                    virsh pool-undefine default
                fi
                echo "Creating new pool for /${hostname}-qemu..."
                virsh pool-define-as --name default --type dir --target /${hostname}-qemu
                virsh pool-autostart default
                virsh pool-start default
            fi
        '';
    };

### Networking

    systemd.services.qemu_verifynetwork = {
        before = [ "dhcpd4.service" "radvd.service" ];
        after = [ "libvirtd.service" ];
        description = "creates brqemu bridge";
        path = [ pkgs.libvirt ];
        wantedBy = [ "multi-user.target" ];
        script = ''
            if ( ! virsh net-info qemunet 2>/dev/null >/dev/null ); then
                xmlpath=$(mktemp)
                echo "
                <network connections='1'>
                    <name>qemunet</name>
                    <forward mode='route'/>
                    <bridge name='brqemu' macTableManager='libvirt'/>
                    <ip address='${ip4net}1' netmask='255.255.255.0'/>
                    <ip family='ipv6' address='${ip6net}1' prefix='64'/>
                </network>
                " > $xmlpath
                virsh net-define $xmlpath
                rm $xmlpath
                virsh net-autostart qemunet
                virsh net-start qemunet
            fi
        '';
    };

### Quagga

    services.quagga.ospf.config = ''
        router ospf
            network ${ip4net}0/24 area 0
    '';

    services.quagga.ospf6.config = ''
        router ospf6
            interface brqemu area 0.0.0.0
    '';

    services.quagga.zebra.config = ''
        interface brqemu
            no link-detect
    '';

### DHCP

    services.dhcpd4.enable = true;
    services.dhcpd4.interfaces = [ "brqemu" ];
    services.dhcpd4.extraConfig = ''
        subnet ${ip4net}0 netmask 255.255.255.0 {
            range ${ip4net}200 ${ip4net}254;
            option subnet-mask 255.255.255.0;
            option broadcast-address ${ip4net}255;
            option routers ${ip4net}1;
            option domain-name-servers 10.90.13.1, 10.90.13.3;
            option domain-name "local.rose.network";
        }
    '';

### radvd

    services.radvd.enable = true;
    services.radvd.config = ''
        interface brqemu {
            IgnoreIfMissing on;
            AdvSendAdvert on;
            prefix ${ip6net}/64 { };
        };
    '';

}
