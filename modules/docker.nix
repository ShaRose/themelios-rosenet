{ config, pkgs, ... }:
{
# Arguments: dockeraddr (all the subnets etc can be calculated from it), hostname

virtualisation.docker.enable = true;
virtualisation.docker.autoPrune.enable = true;

# Filesystem configuration

virtualisation.docker.storageDriver = "zfs";
virtualisation.docker.extraOptions = "--storage-opt zfs.fsname=atlas-pool/docker";
systemd.services.docker_verifyzfs = {
    before = [ "docker.service" ];
    path = [ pkgs.zfs ];
    description = "creates docker zfs filesystems";
    script = ''
zfs create -p -o mountpoint=/atlas-docker atlas-pool/docker
'';
};

# Network configuration

systemd.services.docker_verifynetwork = {
    after = [ "docker.service" ];
    description = "creates routed docker network brdocker";
    path = [ pkgs.docker ];
    script = ''
( docker inspect brdocker 2>/dev/null >/dev/null ) || docker network create --gateway 10.10.5.1 --subnet 10.10.5.0/24 --ipv6 --gateway "2001:470:8c55:1005::1" --subnet "2001:470:8c55:1005::/64" -o "com.docker.network.bridge.name"="brdocker" brdocker >/dev/null
'';
};

services.quagga.ospf.config = ''
router ospf
  network 10.10.5.0/24 area 0
'';
services.quagga.ospf6.config = ''
router ospf6
  interface brdocker area 0.0.0.0
'';

}
