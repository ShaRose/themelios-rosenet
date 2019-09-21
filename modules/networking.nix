{ config, pkgs, ... }:
let
    nicname = "mlxnic";
    nicmac = "00:02:c9:4f:bd:60";
    ipaddr = "10.90.10.103";

    parts = builtins.match "10\.([[:digit:]]{1,2})\.([[:digit:]]{1,2})\.([[:digit:]]{1,3})" ipaddr;

    mainnet = builtins.elemAt parts 0;
    subnet = builtins.elemAt parts 1;
    devnet = builtins.elemAt parts 2;
    psubnet = if (builtins.stringLength subnet) == 1 then ("0" + subnet) else (subnet);

    ip4net = "10.${mainnet}.${subnet}.";
    ip6net = "2001:470:8c55:${mainnet}${psubnet}::";
in
{

networking.usePredictableInterfaceNames = false;
services.udev.extraRules = ''
KERNEL=="eth*", ATTR{address}=="${nicmac}", NAME="${nicname}"
'';

networking.useDHCP = false;

networking.nameservers = [ "10.90.13.1" "10.90.13.2" "10.90.13.3" ];

networking.interfaces.${nicname} = {
    ipv4 = {
        addresses = [ { address = "${ip4net}${devnet}"; prefixLength = 24; } ];
    };
    ipv6 = {
        addresses = [ { address = "${ip6net}${devnet}"; prefixLength = 64; } ];
    };
};

networking.defaultGateway = {
    address = "${ip4net}1";
    interface = "${nicname}";
};

networking.defaultGateway6 = {
    address = "${ip6net}1";
    interface = "${nicname}";
};

}
