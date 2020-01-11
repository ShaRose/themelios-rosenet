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
            hostname = "apollo";
            ipAddr = "10.90.10.106";
            nicName = "mlxnic";
            nicMac = "e8:39:35:4b:04:c7";
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
#bash <(curl https://raw.githubusercontent.com/a-schaefers/themelios/master/themelios) apollo ShaRose/themelios-rosenet
}