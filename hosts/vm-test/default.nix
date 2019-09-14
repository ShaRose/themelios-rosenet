{ config, pkgs, ... }:
# just an example top-level "configuration.nix" file within the themelios scheme
{
imports = [
    ../../modules/users.nix
    ../../modules/tools.nix
];

i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
};

services.udev.extraRules = ''
KERNEL=="eth*", ATTR{address}=="00:0C:29:C8:6F:C9", NAME="testnic"
'';

#networking.interfaces.testnic.ipv4 = {
#    address = "10.99.99.20";
#    prefixLength = 24;
#};

#networking.defaultGateway = {
#    address = "10.99.99.1";
#    interface = "testnic";
#};


time.timeZone = "America/St_Johns";

networking.hostName = "vm-test";
}
