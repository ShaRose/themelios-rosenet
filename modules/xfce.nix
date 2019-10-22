{ config, pkgs, ... }:
{

services.xserver = {
    enable = true;
    desktopManager = {
        default = "xfce4-14";
        xterm.enable = false;
        xfce4-14.enable = true;
    };
};

services.xserver.videoDrivers = [ "vmware" ];

environment.systemPackages = [
    pkgs.google-chrome
];

}
