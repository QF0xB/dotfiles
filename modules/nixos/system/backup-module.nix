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
    ;

  # Define a function to create repository options
  mkRepositoryOptions = {
    eu = mkOption {
      type = types.submodule {
        options = {
          label = mkOption {
            type = types.str;
            description = "Label for the EU repository";
            default = "eu";
          };
          path = mkOption {
            type = types.str;
            description = "Path to the EU repository";
            example = "ssh://uXXXX@uXXXX.eu.repo.borgbase.com/./repo";
            default = "none";
          };
        };
      };
      description = "EU repository configuration";
    };
    na = mkOption {
      type = types.submodule {
        options = {
          label = mkOption {
            type = types.str;
            description = "Label for the NA repository";
            default = "na";
          };
          path = mkOption {
            type = types.str;
            description = "Path to the NA repository";
            example = "ssh://uXXXX@uXXXX.us.repo.borgbase.com/./repo";
            default = "none";
          };
        };
      };
      description = "NA repository configuration";
    };
    as = mkOption {
      type = types.submodule {
        options = {
          label = mkOption {
            type = types.str;
            description = "Label for the AS repository";
            default = "as";
          };
          path = mkOption {
            type = types.str;
            description = "Path to the AS repository";
            example = "ssh://uXXXX@uXXXX.as.repo.borgbase.com/./repo";
            default = "none";
          };
        };
      };
      description = "AS repository configuration";
    };
    au = mkOption {
      type = types.submodule {
        options = {
          label = mkOption {
            type = types.str;
            description = "Label for the AU repository";
            default = "au";
          };
          path = mkOption {
            type = types.str;
            description = "Path to the AU repository";
            example = "ssh://uXXXX@uXXXX.au.repo.borgbase.com/./repo";
            default = "none";
          };
        };
      };
      description = "AU repository configuration";
    };
  };
  formatRepositories = repos: lib.filter (repo: repo.path != "none") (lib.attrValues repos);
in
{
  options.qnix.system.backup = {
    enable = mkEnableOption "Borgmatic backup service" // {
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
        default = "backup";
      };
    };
  };

  config = mkIf cfg.enable {
    # Create borgmatic configuration
    services.borgmatic = {
      enable = true;

      # Single configuration for all repositories
      configurations = {
        "system-backup-${cfg.hostname}" = {
          repositories = formatRepositories cfg.repositories.${cfg.hostname};
          source_directories = [ "/tmp/zfs-backups" ];
          exclude_patterns = [ "*.tmp" ];
          encryption_passcommand = "cat ${config.sops.secrets."backup_${cfg.hostname}_passphrase".path}";
          ssh_command = "ssh -o StrictHostKeyChecking=accept-new -i ${
            config.sops.secrets."backup_${cfg.hostname}_key".path
          }";
          compression = "auto,lzma";

          # Append-only mode for non-prune machines
          append_only = !cfg.prune.enable;

          # Prune settings (only used when prune.enable is true)
          keep_hourly = cfg.prune.keep.hourly;
          keep_daily = cfg.prune.keep.daily;
          keep_weekly = cfg.prune.keep.weekly;
          keep_monthly = cfg.prune.keep.monthly;
          keep_yearly = cfg.prune.keep.yearly;

          # Additional options
          files_cache_ttl = 30;

          # Before backup hook to create ZFS snapshots
          before_backup = mkIf (!cfg.prune.enable) ''
            # Debug filesystem status
            # Create backup directory if it doesn't exist
            mkdir -p /tmp/zfs-backups

            echo "Filesystem status:"
            df -h /tmp/zfs-backups

            # Check if directory is writable
            touch /tmp/zfs-backups/test_write
            if [ $? -ne 0 ]; then
              echo "ERROR: Cannot write to /tmp/zfs-backups"
              exit 1
            fi
            rm /tmp/zfs-backups/test_write

            # Create a snapshot with timestamp
            SNAPSHOT_NAME="${cfg.zfs.snapshotName}-$(date +%Y%m%d-%H%M%S)"
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

          # After backup hook to clean up old backup files
          after_backup = mkIf (!cfg.prune.enable) ''
            find /tmp/zfs-backups -name "${cfg.hostname}-${cfg.zfs.snapshotName}-*.zfs" | sort | head -n -1 | xargs -r rm
          '';

          # After prune hook to compact the repository
          after_prune = mkIf cfg.prune.enable ''
            borg compact "$REPOSITORY"
          '';
        };
      };

      # Schedule backups
      settings = {
        location = {
          # For backup machines, run daily
          # For prune machines, run weekly
          schedule = if cfg.prune.enable then "weekly" else "daily";
        };

        # Skip creating backups on prune machines
        borgmatic.create = mkIf cfg.prune.enable false;
        # Only run prune on prune machines
        borgmatic.prune = cfg.prune.enable;
        # Run check periodically
        borgmatic.check = true;
        # Initialize repositories
        borgmatic.init = true;
      };
    };

    # Create directory for ZFS backup files
    system.activationScripts.createZfsBackupDir = ''
      mkdir -p /var/lib/zfs-backups
      mkdir -p /tmp/zfs-backups
    '';
  };
}
