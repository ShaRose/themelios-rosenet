{ config, pkgs, ... }:
# just an example top-level "configuration.nix" file within the themelios scheme
{
imports = [
    ../../modules/users.nix
    ../../modules/tools.nix
];


imports = [ ../../modules/tools.nix ];

i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
};

networking.usePredictableInterfaceNames = false;
services.udev.extraRules = ''
KERNEL=="eth*", ATTR{address}=="00:02:c9:4f:bd:60", NAME="mlxnic"
'';

networking.useDHCP = false;

networking.nameservers = [ "10.90.13.1" "10.90.13.2" "10.90.13.3" ];

networking.interfaces.mlxnic = {
    ipv4 = {
        addresses = [ { address = "10.90.10.103"; prefixLength = 24; } ];
    };
    ipv6 = {
        addresses = [ { address = "2001:470:8c55:9010::103"; prefixLength = 64; } ];
    };
};

networking.defaultGateway = {
    address = "10.90.10.1";
    interface = "mlxnic";
};

networking.defaultGateway6 = {
    address = "2001:470:8c55:9010::1";
    interface = "mlxnic";
};


services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
};

time.timeZone = "America/St_Johns";

networking.hostName = "atlas";
}
