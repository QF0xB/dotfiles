{
  config,
  lib,
  pkgs,
  host,
  ...
}:

let
  cfg = config.qnix.system.backup;

  inherit (lib)
    mkIf
    mkOption
    types
    mkEnableOption
    flip
    mapAttrs'
    nameValuePair
    mkForce
    ;

  # Define a function to create repository options
  mkRepositoryOptions = {
    local = mkOption {
      type = types.str;
      description = "An local repository of borg. It backups the /cache directory as well.";
      example = "user@nas01.localdomain/";
      default = "none";
    };
    eu = mkOption {
      type = types.str;
      description = "An EU repository of borg. Keep empty to ignore.";
      example = "uXXXX@uXXXX.eu.repo.borgbase.com/";
      default = "none";
    };
    us = mkOption {
      type = types.str;
      description = "An US repository of borg. Keep empty to ignore.";
      example = "uXXXX@uXXXX.us.repo.borgbase.com/";
      default = "none";
    };
    as = mkOption {
      type = types.str;
      description = "An Asian repository of borg. Keep empty to ignore.";
      example = "uXXXX@uXXXX.as.repo.borgbase.com/";
      default = "none";
    };
    au = mkOption {
      type = types.str;
      description = "An Australian repository of borg. Keep empty to ignore.";
      example = "uXXXX@uXXXX.au.repo.borgbase.com/";
      default = "none";
    };
  };

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
  options.qnix.system.backup = with lib; {
    enable = mkEnableOption "Borg backup service" // {
      default = true;
    };

    hostname = mkOption {
      type = types.str;
      default = host;
      description = "The hostname of this machine";
    };

    repositories = {
      QFrame13 = mkRepositoryOptions;
      QPC = mkRepositoryOptions;
    };

    # Pruning options
    prune = {
      enable = mkEnableOption "Allow this machine to prune backups";

      keep = {
        hourly = mkOption {
          type = types.int;
          description = "Number of hourly backups to keep";
          default = 0;
        };

        daily = mkOption {
          type = types.int;
          description = "Number of daily backups to keep";
          default = 7;
        };

        weekly = mkOption {
          type = types.int;
          description = "Number of weekly backups to keep";
          default = 4;
        };

        monthly = mkOption {
          type = types.int;
          description = "Number of monthly backups to keep";
          default = 6;
        };

        yearly = mkOption {
          type = types.int;
          description = "Number of yearly backups to keep";
          default = 1;
        };
      };
    };

    # ZFS options
    zfs = {
      enable = mkEnableOption "ZFS backup features" // {
        default = true;
      };

      datasets = mkOption {
        type = types.listOf types.str;
        description = "List of ZFS datasets to backup";
        default = [ ];
        example = [
          "safe/home"
          "safe/persist"
        ];
      };

      snapshotName = mkOption {
        type = types.str;
        description = "Prefix for ZFS snapshots created for backup";
        default = "backup-${cfg.hostname}";
      };
    };
  };

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
