{ config, pkgs, ... }:
{

programs.mtr.enable = true;
programs.bash.enableCompletion = true;
programs.tmux.enable = true;
programs.htop.enable = true;
programs.iftop.enable = true;
programs.iotop.enable = true;
programs.less.enable = true;
programs.vim.defaultEditor = true;

environment.systemPackages = [
pkgs.mbuffer
];

}