{ config, pkgs, ... }:
{
virtualisation.docker.enable = true;
virtualisation.docker.autoPrune.enable = true;
virtualisation.docker.storageDriver = "zfs";
#virtualisation.docker.extraOptions = "";
}
