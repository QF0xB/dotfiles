{
  config,
  lib,
  pkgs,
  host,
  ...
}:

let
  cfg = config.hm.qnix.applications.security.backup;

  inherit (lib)
    mkIf
    flip
    mapAttrs'
    nameValuePair
    mkForce
    ;

  # Function to create a backup job for a specific repository
  mkBackupJob =
    repoLocation: repoUrl:
    mkIf (repoUrl != "none" && !cfg.prune.enable) {
      paths = [ "/tmp/zfs-backups-${repoLocation}" ]; # Directory where ZFS snapshot files are stored
      exclude = [ "*.tmp" ];
      repo = repoUrl;
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${config.sops.secrets."backup_${cfg.hostname}_passphrase".path}";
      };
      extraInitArgs = [ "--append-only" ];
      environment = {
        BORG_RSH = "ssh -o StrictHostKeyChecking=accept-new -i ${
          config.sops.secrets."backup_${cfg.hostname}_key".path
        }";
        BORG_APPEND_ONLY = "1";
        BORG_FILES_CACHE_TTL = "30";
      };
      compression = "auto,lzma";
      startAt = "daily";

      # Create ZFS snapshot file before backup
      preHook = ''
        # Debug filesystem status
        # Create backup directory if it doesn't exist
        mkdir -p /tmp/zfs-backups-${repoLocation}

        echo "Filesystem status:"
        df -h /tmp/zfs-backups-${repoLocation}

        # Create backup directory if it doesn't exist
        mkdir -p /tmp/zfs-backups-${repoLocation}

        # Check if directory is writable
        touch /tmp/zfs-backups-${repoLocation}/test_write
        if [ $? -ne 0 ]; then
          echo "ERROR: Cannot write to /tmp/zfs-backups-${repoLocation}"
          exit 1
        fi
        rm /tmp/zfs-backups-${repoLocation}/test_write

        # Create backup directory if it doesn't exist
        mkdir -p /tmp/zfs-backups-${repoLocation}

        # Create a snapshot with timestamp
        SNAPSHOT_NAME="${cfg.zfs.snapshotName}-${repoLocation}-$(date +%Y%m%d-%H%M%S)"
        BACKUP_FILE="/tmp/zfs-backups-${repoLocation}/${cfg.hostname}-$SNAPSHOT_NAME.zfs"

        # Create snapshots of datasets
        ${lib.concatMapStringsSep "\n"
          (dataset: ''
            echo "Creating snapshot zroot/${dataset}@${dataset}_$SNAPSHOT_NAME"
            ${pkgs.zfs}/bin/zfs snapshot zroot/${dataset}@${dataset}_$SNAPSHOT_NAME
          '')
          (
            lib.concatLists [
              cfg.zfs.datasets
              (lib.lists.optionals (repoLocation == "local") [ "cache" ])
            ]
          )
        }

        # Send the snapshots to a file
        ${lib.concatMapStringsSep "\n"
          (dataset: ''
            echo "Sending zroot/${dataset}@${dataset}_$SNAPSHOT_NAME to file"
            ${pkgs.zfs}/bin/zfs send --raw -R zroot/${dataset}@${dataset}_$SNAPSHOT_NAME > "/tmp/zfs-backups-${repoLocation}/${cfg.hostname}-${dataset}-$SNAPSHOT_NAME.zfs"
          '')
          (
            lib.concatLists [
              cfg.zfs.datasets
              (lib.lists.optionals (repoLocation == "local") [ "cache" ])
            ]
          )
        }
      '';

      # Clean up old backup files (but not ZFS snapshots)
      postHook = ''
        rm -r /tmp/zfs-backups-${repoLocation}
      '';
    };

  # Function to create a prune job for a specific repository
  mkPruneJob =
    repoLocation: repoUrl:
    mkIf (repoUrl != "none" && cfg.prune.enable) {
      paths = [ ]; # No actual backup, just pruning
      repo = repoUrl;
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${config.sops.secrets."backup_${cfg.hostname}_passphrase".path}";
      };
      environment = {
        BORG_RSH = "ssh -o StrictHostKeyChecking=accept-new -i ${
          config.sops.secrets."backup_${cfg.hostname}_key".path
        }";
      };
      startAt = "weekly";

      # Skip the actual backup
      extraCreateArgs = "--dry-run";

      # Prune configuration
      prune = {
        keep = {
          hourly = cfg.prune.keep.hourly;
          daily = cfg.prune.keep.daily;
          weekly = cfg.prune.keep.weekly;
          monthly = cfg.prune.keep.monthly;
          yearly = cfg.prune.keep.yearly;
        };
      };

      # Run compact after pruning to free up space
      postPruneHook = ''
        ${pkgs.borgbackup}/bin/borg compact "$REPO_URL"
      '';
    };
in
{
  config = mkIf cfg.enable {
    # Create backup jobs for all non-empty repositories
    services.borgbackup.jobs = lib.mkMerge [
      # Backup jobs (only on non-pruning machines)
      (mkIf (!cfg.prune.enable) {
        system-backup-eu = mkBackupJob "eu" cfg.repositories.${cfg.hostname}.eu;
        system-backup-na = mkBackupJob "us" cfg.repositories.${cfg.hostname}.us;
        system-backup-as = mkBackupJob "as" cfg.repositories.${cfg.hostname}.as;
        system-backup-au = mkBackupJob "au" cfg.repositories.${cfg.hostname}.au;
        system-backup-local = mkBackupJob "local" cfg.repositories.${cfg.hostname}.local;
      })

      # Prune jobs (only on pruning machines)
      (mkIf cfg.prune.enable {
        prune-eu = mkPruneJob "eu" cfg.repositories.${cfg.hostname}.eu;
        prune-na = mkPruneJob "us" cfg.repositories.${cfg.hostname}.us;
        prune-as = mkPruneJob "as" cfg.repositories.${cfg.hostname}.as;
        prune-au = mkPruneJob "au" cfg.repositories.${cfg.hostname}.au;
        prune-local = mkPruneJob "local" cfg.repositories.${cfg.hostname}.local;
      })
    ];

    systemd.timers = flip mapAttrs' config.services.borgbackup.jobs (
      name: value:
      nameValuePair "borgbackup-job-${name}" {
        unitConfig.OnFailure = "notify-problems@%i.service";
        timerConfig.Persistent = mkForce true;
      }
    );

    # Create directory for ZFS backup files
    system.activationScripts.createZfsBackupDir = ''
      mkdir -p /var/lib/zfs-backups
    '';

    # Add this to your module
    systemd.services.init-borg-repos = {
      description = "Initialize Borg Repositories";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      # Run only once when the service is first enabled
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      # Environment setup for Borg
      environment = {
        BORG_PASSPHRASE_COMMAND = "cat ${config.sops.secrets."backup_${cfg.hostname}_passphrase".path}";
        BORG_RSH = "ssh -o StrictHostKeyChecking=accept-new -i ${
          config.sops.secrets."backup_${cfg.hostname}_key".path
        }";
        BORG_APPEND_ONLY = mkIf (!cfg.prune.enable) "1";
      };

    };
  };
}
