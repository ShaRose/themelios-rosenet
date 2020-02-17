{ config, pkgs, lib, ... }:
with lib;
with types;
{

#    options = {
#        systeminfo = mkOption {
#            type = attrs;
#            description = "System Information for configuration";
#        };
#    };
#    config = {
#        systeminfo = {
#            hostname = "helios";
#            ipAddr = "10.90.10.101";
#            nicName = "gbnic";
#            nicMac = "b8:97:5a:96:0d:4e";
#        };
#    };

# Temporary test config

    networking.hostName = "helios";
    networking.usePredictableInterfaceNames = false;
    services.udev.extraRules = ''
        KERNEL=="eth*", ATTR{address}=="b8:97:5a:96:0d:4e", NAME="gbnic"
        KERNEL=="eth*", ATTR{address}=="74:da:38:3b:0f:d9", NAME="wlaniot"
    '';
    
    networking.networkmanager.unmanaged = [ "interface-name:wlaniot" ]
    
    services.hostapd = {
        enable        = true;
        interface     = "wlaniot";
        hwMode        = "g";
        ssid          = "RoseHome-IoT";
        # Testing password
        wpaPassphrase = "NcN8fz57zBLswiZ63Wum3HdwhnBaC9zrGCWNLZc8";
        extraConfig = ''
            ignore_broadcast_ssid=1
        '';
    };

    networking.interfaces.wlaniot = {
        ipv4 = {
            addresses = [ { address = "10.70.0.1"; prefixLength = 24; } ];
        };
    };
    
    services.dnsmasq = lib.optionalAttrs config.services.hostapd.enable {
        enable = true;
        extraConfig = ''
            interface=wlaniot
            bind-interfaces
            dhcp-range=10.70.0.10,10.70.0.254,24h
        '';
    };

    networking.firewall.allowedUDPPorts = [53 67]; # DNS & DHCP

    networking.useDHCP = false;
    networking.nameservers = [ "8.8.8.8" ];
    networking.interfaces.gbnic = {
        ipv4 = {
            addresses = [ { address = "192.168.0.5"; prefixLength = 24; } ];
        };
    };

    networking.defaultGateway = {
        address = "192.168.0.1";
        interface = "gbnic";
    };

    imports = [
        ../../modules/users.nix
        ../../modules/tools.nix
        ../../modules/common.nix
        #../../modules/networking.nix
        #../../modules/quagga.nix
        ../../modules/automatic-upgrades.nix
    ];
#bash <(curl https://raw.githubusercontent.com/a-schaefers/themelios/master/themelios) helios ShaRose/themelios-rosenet
}

