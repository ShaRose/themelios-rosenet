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
            hostname = "chronos";
            ipAddr = "10.90.10.101";
            nicName = "mlxnic";
            nicMac = "00:02:c9:4e:5c:9c";
        };
    };

    imports = [
        ../../modules/users.nix
        ../../modules/tools.nix
        ../../modules/common.nix
        ../../modules/networking.nix
        ../../modules/quagga.nix
        ../../modules/automatic-upgrades.nix
    ];
#bash <(curl https://raw.githubusercontent.com/a-schaefers/themelios/master/themelios) chronos ShaRose/themelios-rosenet
}

