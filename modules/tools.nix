{ config, pkgs, ... }:
{

    imports = [
        ../../modules/unstable-packages.nix
    ];

    programs.bash.enableCompletion = true;
    programs.vim.defaultEditor = true;

    environment.systemPackages = with pkgs; [
        mbuffer
        htop
        tcpdump
        cifs-utils
        gitMinimal
        wget
        parallel
        lz4
        tmux
        htop
        iotop
        sysstat
        less
        mtr
        iftop
        usbutils
        lsof
        dnsutils
        file
    ];

}
