{ config, pkgs, ... }:
{

programs.mtr.enable = true;
programs.bash.enableCompletion = true;
programs.tmux.enable = true;
programs.iftop.enable = true;
programs.iotop.enable = true;
programs.less.enable = true;
programs.vim.defaultEditor = true;

environment.systemPackages = [
pkgs.mbuffer
pkgs.htop
pkgs.tcpdump
pkgs.cifs-utils
pkgs.gitMinimal
pkg.wget
];

}
