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
            hostname = "vm-test";
            ipAddr = "10.99.99.20";
            nicName = "vmnic";
            nicMac = "00:0c:29:c8:6f:c9";
        };
    };

    imports = [
        ../../modules/users.nix
        ../../modules/tools.nix
        ../../modules/common.nix
        ../../modules/networking.nix
        ../../modules/xfce.nix
        ../../modules/automatic-upgrades.nix
        ../../modules/unstable-packages.nix
        ../../modules/tools-unstable.nix
    ];

#bash <(curl https://raw.githubusercontent.com/a-schaefers/themelios/master/themelios) vm-test ShaRose/themelios-rosenet
}

