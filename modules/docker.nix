{ config, pkgs, ... }:
let
    dockeraddr = "10.10.5.1";
    hostname = "atlas";

    parts = builtins.match "10\.([[:digit:]]{1,2})\.([[:digit:]]{1,2})\.1" dockeraddr;

    mainnet = builtins.elemAt parts 0;
    subnet = builtins.elemAt parts 1;
    psubnet = if (builtins.stringLength subnet) == 1 then ("0" + subnet) else (subnet);

    ip4net = "10.${mainnet}.${subnet}.";
    ip6net = "2001:470:8c55:${mainnet}${psubnet}::";
in
{
    virtualisation.docker.enable = true;
    virtualisation.docker.autoPrune.enable = true;

### Filesystem configuration

    virtualisation.docker.storageDriver = "zfs";
    virtualisation.docker.extraOptions = "--storage-opt zfs.fsname=${hostname}-pool/docker";
    systemd.services.docker_verifyzfs = {
        before = [ "docker.service" ];
        path = [ pkgs.zfs ];
        wantedBy = [ "multi-user.target" ];
        description = "creates docker zfs filesystems";
        script = ''
            zfs create -p -o mountpoint=/${hostname}-docker ${hostname}-pool/docker
        '';
    };

### Network configuration

    systemd.services.docker_verifynetwork = {
        after = [ "docker.service" ];
        description = "creates routed docker network brdocker";
        path = [ pkgs.docker ];
        wantedBy = [ "multi-user.target" ];
        script = ''
            if ( ! docker inspect brdocker 2>/dev/null >/dev/null ); then
                docker network create --gateway ${ip4net}1 --subnet ${ip4net}0/24 \
                    --ipv6 --gateway "${ip6net}1" --subnet "${ip6net}/64" \
                    -o "com.docker.network.bridge.name"="brdocker" brdocker >/dev/null
            fi
        '';
    };

    services.quagga.ospf.config = ''
        router ospf
            network ${ip4net}0/24 area 0
    '';
    services.quagga.ospf6.config = ''
        router ospf6
            interface brdocker area 0.0.0.0
    '';
}
