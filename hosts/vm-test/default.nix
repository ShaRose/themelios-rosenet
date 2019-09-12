{ config, pkgs, ... }:
# just an example top-level "configuration.nix" file within the themelios scheme
{
imports = [
../../modules/users.nix
];

i18n = {
consoleFont = "Lat2-Terminus16";
consoleKeyMap = "us";
defaultLocale = "en_US.UTF-8";
};

time.timeZone = "America/St_Johns";

programs.mtr.enable = true;
programs.bash.enableCompletion = true;

networking.hostName = "vm-test";
}
