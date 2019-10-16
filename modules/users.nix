{ config, pkgs, ... }:
{

security.sudo.wheelNeedsPassword = false;

users.mutableUsers = false;

users.users.root.hashedPassword = "$6$TeCIauhkcy$3gVFf/Dledmm1E92OVLNT8HpsTuXkQTpn2EJ01lrxVKOkN7EGPxnQNbKLBnWRvzYDiNpLUBrlvlTDblecv8q/1";

users.users.sharoseadmin = {
    description = "Shawn Rose (Administrator)";
    isNormalUser = true;
    uid = 1000;
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIshYq7EtxLl4A7fcc0x1qY+45a9+bE2JROKN9uvsIf7 sharose-mobaterm-2017-11-03"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZguO6feHZfgHguULstTlfnHJR7sCkoe4w2i8yRUc6FbLmgHdAon+T0YMMwxUc51AgyRovlvMwiIk0sizoLbbrDwgpOpiEHW7AyCzuCOLzTBo4DXW/V5Q/layIod9IgcWgIoodZR5aTzaA0R+x7zoz6Lfa1XrGKQDIAgXI9JHYrjf3Kv+6Oo2nnBxfcSISqMwtHLQ74hJrBF8uuxBGsifqHpZRyz6ZE7DBL9DATOolvA/7gKOioIgAliUyCemtr/0qLpBd9mYzC3BhR1mGjDk/B1ekWMpalKjgri3eBNWdyjlnsCj8xGVwOSiNNl969C+w28sx2tkLhY3nXLhHZt9SRr5eZ++fVivCl8f3YmOY/PGfXVVh6lLyeDnWl4pRvsw4LmDgyLxYJ1X8KfIR71oR9zeME4riQpguFiMVzxKNlGeXGjR/uUd7wjIMwwtBqy4Z5Cily8RIZqHvRbme8uPCJl4BVrqGMFR/16t1t8MqCzYl6TGklvGBIAa2ftaDcYTSLh7bDQYz44YVxVC6R/bVM+0Wg2ZbRyFwBo2lv1tF5hmX3b5zIBCePTUKsiGuQ7xWIQW4aQoG/905b7OfC9/EgC9IJVSJRC/M3vqXkbkFRCqYzJQEpgrsO28E5RolIuh2mRY+W3rs+MB4F1122XjeE4ktomG8pXpXyb6Tg8S/zw== webvirtcloud"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvGgkzX19oHhwS18dr+D++bYhFVxCZxF+xiTixHALeXPNxBycZdU7Udqdirp8NOYl5hMdz2er0ZXs1XXfue2opt/1M6y/Qyfkeuo7FNwCjh/p+p1hWreLQnnMRRVvxCBpPGL5WtwW9GxA+k6TOrhVRFToS0G6HRdnB2D/2IqZzxnUUPQc+a5C/2P5kUvPy2dI8lbDonQ53eTOfhtjPbLFyzuzP1jLP6uvJTc+dZ8LpPQ5FOXjNZluu2IT36RpKsWMENL7vyc2Ncl1Mr3caCqrXBSAMjBYKObp2AA1C1jMuIOHjKpHrXOexcjgGHmpwuctJ4JLQXpGUM2LvwLx7eD/V8xBwFv3RUKhBO6uOAdz5cSlL15J+a39Wou/Fkw4Rb5nTV99tXl7LOfeZeoQ9RVJ27v7nckRLQfdh5sUHjalDhaFM/MzbZ4lEYI6o+ANzZa+YbZwPRzTq0ZBgYwvXnn/h+g4SVTwcir+3o5j+0AFnXi7iwDoL6oTGua9vk8XgyzYFzlcb02k42jp45HZzYUbN2Iod+nKLUxXjr7DyJuMyLAJmrjjzEjuT3mQOgRKyp0Bl3+P+nKsHp9OEvRg/948p87J6nOB8E4twis6gzmUrHDtQbM6wDhp2lIm2DIyllgaoBE2qv3hsHbiqQnBp6g2lW9YEw651eX120GYowD7rYQ== cardno:000607181393"
    ];
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$3LAu88GY3tSWNkQu$1wlJj42QK/9OpaEdMjcAI03XIeiz8h3FSEvW7KI5PsOi9cZ8jugEwLuqyXLMEdphaUMYvm/za4vJ9fSAPUARd.";
};
}
