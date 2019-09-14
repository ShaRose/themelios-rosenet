{ config, pkgs, ... }:
# just an example top-level "configuration.nix" file within the themelios scheme
{
imports = [
#    ../../modules/users.nix
    ../../modules/tools.nix
];

i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
};

networking.usePredictableInterfaceNames = false;
services.udev.extraRules = ''
KERNEL=="eth*", ATTR{address}=="00:0c:29:c8:6f:c9", NAME="testnic"
'';

networking.useDHCP = false;

networking.nameservers = [ "10.99.99.1" ];

networking.interfaces.testnic = {
    ipv4 = {
        addresses = [ { address = "10.99.99.20"; prefixLength = 24; } ];
    };
    ipv6 = {
        addresses = [ { address = "2001:470:8c55:9999::20"; prefixLength = 64; } ];
    };
};

networking.defaultGateway = {
    address = "10.99.99.1";
    interface = "testnic";
};

networking.defaultGateway6 = {
    address = "2001:470:8c55:9999::1";
    interface = "testnic";
};


time.timeZone = "America/St_Johns";

networking.hostName = "vm-test";
}
