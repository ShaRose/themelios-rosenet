{ config, pkgs, ... }:
{

    programs.bash.enableCompletion = true;
    programs.vim.defaultEditor = true;

    environment.systemPackages = [
        pkgs.mbuffer
        pkgs.htop
        pkgs.tcpdump
        pkgs.cifs-utils
        pkgs.gitMinimal
        pkgs.wget
        pkgs.parallel
        pkgs.lz4
        pkgs.tmux
        pkgs.htop
        pkgs.iotop
        pkgs.sysstat
        pkgs.less
        pkgs.mtr
        pkgs.iftop
        pkgs.usbutils
        pkgs.lsof
    ];

}
