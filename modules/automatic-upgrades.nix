{ config, pkgs, ... }:
{
    system.autoUpgrade.enable = true;
    
    systemd.timers.nix-config-git-pull = {
        enable = true;
        description = "Updates the contents of /nix-config via git pull";
        serviceConfig.Type = "oneshot";
        path = with pkgs; [ git ];
        startAt = "04:00";
        script = ''
            git -C /nix-config/ pull
        '';
    };
}
