{
  config,
  lib,
  pkgs,
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
    eu = mkOption {
      type = types.str;
      description = "An EU repository of borg. Keep empty to ignore.";
      example = "uXXXX@uXXXX.eu.repo.borgbase.com/";
      default = "none";
    };
    na = mkOption {
      type = types.str;
      description = "An NA repository of borg. Keep empty to ignore.";
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
      paths = [ "/tmp/zfs-backups" ]; # Directory where ZFS snapshot files are stored
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
        mkdir -p /tmp/zfs-backups

        echo "Filesystem status:"
        df -h /tmp/zfs-backups

        # Create backup directory if it doesn't exist
        mkdir -p /tmp/zfs-backups

        # Check if directory is writable
        touch /tmp/zfs-backups/test_write
        if [ $? -ne 0 ]; then
          echo "ERROR: Cannot write to /tmp/zfs-backups"
          exit 1
        fi
        rm /tmp/zfs-backups/test_write

        # Create backup directory if it doesn't exist
        mkdir -p /tmp/zfs-backups

        # Create a snapshot with timestamp
        SNAPSHOT_NAME="${cfg.zfs.snapshotName}-${repoLocation}-$(date +%Y%m%d-%H%M%S)"
        BACKUP_FILE="/tmp/zfs-backups/${cfg.hostname}-$SNAPSHOT_NAME.zfs"

        # Create snapshots of datasets
        ${lib.concatMapStringsSep "\n" (dataset: ''
          echo "Creating snapshot ${dataset}@$SNAPSHOT_NAME"
          ${pkgs.zfs}/bin/zfs snapshot ${dataset}@$SNAPSHOT_NAME
        '') cfg.zfs.datasets}

        # Send the snapshots to a file
        ${lib.concatMapStringsSep "\n" (dataset: ''
          echo "Sending ${dataset}@$SNAPSHOT_NAME to file"
          ${pkgs.zfs}/bin/zfs send --raw -R ${dataset}@$SNAPSHOT_NAME > $BACKUP_FILE
        '') cfg.zfs.datasets}
      '';

      # Clean up old backup files (but not ZFS snapshots)
      postHook = ''
        find /tmp/zfs-backups -name "${cfg.hostname}-${cfg.zfs.snapshotName}-*.zfs" | sort | head -n -1 | xargs -r rm
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
      type = types.enum [
        "QFrame13"
        "QPC"
      ];
      description = "The hostname of this machine (QFrame13 or QPC)";
      example = "QFrame13";
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
          "rpool/safe/home"
          "rpool/safe/persist"
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
        system-backup-na = mkBackupJob "na" cfg.repositories.${cfg.hostname}.na;
        system-backup-as = mkBackupJob "as" cfg.repositories.${cfg.hostname}.as;
        system-backup-au = mkBackupJob "au" cfg.repositories.${cfg.hostname}.au;
      })

      # Prune jobs (only on pruning machines)
      (mkIf cfg.prune.enable {
        prune-eu = mkPruneJob "eu" cfg.repositories.${cfg.hostname}.eu;
        prune-na = mkPruneJob "na" cfg.repositories.${cfg.hostname}.na;
        prune-as = mkPruneJob "as" cfg.repositories.${cfg.hostname}.as;
        prune-au = mkPruneJob "au" cfg.repositories.${cfg.hostname}.au;
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
