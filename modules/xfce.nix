{ config, pkgs, ... }:
{

services.xserver = {
    enable = true;
    desktopManager = {
        default = "xfce";
        xterm.enable = false;
        xfce.enable = true;
    };
};

}
