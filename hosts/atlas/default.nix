{ config, pkgs, ... }:
{

#ipaddr = "10.90.10.103"
#nicname = "mlxnic"
#nicmac = "00:02:c9:4f:bd:60"
#qemuaddr = "10.10.3.1"

imports = [
    ../../modules/users.nix
    ../../modules/tools.nix
    ../../modules/common.nix
    ../../modules/networking.nix
    ../../modules/quagga.nix
    ../../modules/qemu.nix
    ../../modules/docker.nix
];

    networking.hostName = "atlas";

    #Testing, so security can suck it
    security.sudo.wheelNeedsPassword = false;

}
