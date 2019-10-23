{ config, pkgs, ... }:
{

services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
    desktopManager = {
#      default = "xfce";
#      xfce.enable = true;
#      gnome3.enable = true;
      plasma5.enable = true;
    };
    # windowManager.xmonad = {
    #   enable = true;
    #   enableContribAndExtras = true;
    #   extraPackages = h: with h; [
    #     MissingH
    #   ];
    # };
    exportConfiguration = true;
    videoDrivers = [ "vmware" ];
  };

environment.systemPackages = with pkgs; [
    chromium
    virtviewer
];

}
