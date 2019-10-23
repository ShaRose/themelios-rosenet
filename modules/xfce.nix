{ config, pkgs, ... }:
{

services.xserver = {
    enable = true;
    desktopManager = {
      xfce.enable = true;
    };
    exportConfiguration = true;
    videoDrivers = [ "vmware" ];
  };

environment.systemPackages = with pkgs; [
    chromium
    virtmanager
    
];

}
