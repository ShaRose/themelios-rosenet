{ config, pkgs, ... }:
{

# Arguments: none

i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
};

services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
};

time.timeZone = "America/St_Johns";

}
