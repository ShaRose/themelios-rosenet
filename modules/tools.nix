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
        pkg.wget
        pkg.parallel
        pkg.lz4
        pkg.tmux
        pkg.htop
        pkg.iotop
        pkg.sysstat
        pkg.less
        pkg.mtr
        pkg.iftop
        pkg.usbutils
        pkg.lsof
    ];

}
