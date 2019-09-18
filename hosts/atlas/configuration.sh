# Themelios configuration.sh example

use_sgdisk_clear="true"     # use sgdisk --clear
use_wipefs_all="true"       # use wipefs --all
use_zero_disks="false"      # use dd if=/dev/zero ...
zfs_pool_name="atlas-pool"
zfs_pool_disks=("/dev/disk/by-id/ata-Micron_M600_MTFDDAK1T0MBF_14410D7D9456")
zfs_pool_type=""            # use "" for single, or "mirror", "raidz1", etc.
zfs_encrypt_home="false"    # only set to true if you are using a nixos ISO with ZFS 0.8 or higher.
zfs_auto_snapshot=() # datasets to be set with com.sun:auto-snapshot=true
nix_top_level_configuration="hosts/atlas" # Your top-level nix file to be bootstrapped
nix_zfs_configuration_extra_enabled="false" # uncomment below if set to true
nix_zfs_extra_auto_scrub="true"
nix_zfs_extra_auto_snapshot_enabled="false" # Enable the ZFS auto-snapshotting service
nix_zfs_extra_auto_snapshot_frequent="0"
nix_zfs_extra_auto_snapshot_hourly="0"
nix_zfs_extra_auto_snapshot_daily="0"
nix_zfs_extra_auto_snapshot_weekly="0"
nix_zfs_extra_auto_snapshot_monthly="0"
nix_zfs_extra_auto_optimise_store="true"
nix_zfs_extra_gc_automatic="true"
nix_zfs_extra_gc_dates="weekly"
nix_zfs_extra_gc_options="--delete-older-than 14d"
nix_zfs_extra_clean_tmp_dir="true"
