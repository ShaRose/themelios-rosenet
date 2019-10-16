{ config, pkgs, lib, ... }:
with lib;
with types;
{

    options = {
        systeminfo = mkOption {
            type = attrs;
            description = "System Information for configuration";
        };
    };
    config = {
        systeminfo = {
            hostname = "atlas";
            ipAddr = "10.90.10.103";
            nicName = "mlxnic";
            nicMac = "00:02:c9:4f:bd:60";
            qemuAddr = "10.10.3.1";
            dnsAddr = "10.90.13.2";
            dockerAddr = "10.10.5.1";
        };
    };

imports = [
    ../../modules/users.nix
    ../../modules/tools.nix
    ../../modules/common.nix
    ../../modules/networking.nix
    ../../modules/quagga.nix
    ../../modules/dnsdist.nix
    ../../modules/qemu.nix
    ../../modules/docker.nix
];

#bash <(curl https://raw.githubusercontent.com/a-schaefers/themelios/master/themelios) atlas ShaRose/themelios-rosenet
}

