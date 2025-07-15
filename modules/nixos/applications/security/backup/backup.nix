{
  config,
  lib,
  pkgs,
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

  prefixFile = repoLocation: "/run/borgbackup-${repoLocation}.prefix";

  # Shared logic outside mkBackupJob
  generateSnapshotPrefix =
    repoLocation:
    "${cfg.zfs.snapshotName}-${repoLocation}-\$(${pkgs.coreutils}/bin/date +%Y%m%d-%H%M%S)";

  genDatasetCommands =
    repoLocation: snapshotPrefix:
    lib.concatMapStringsSep "\n"
      (dataset: ''
        SNAPNAME="${dataset}_${snapshotPrefix}"
        CLONE_NAME="backup-${dataset}-${snapshotPrefix}"
        MOUNTPOINT="/run/backup-mounts/${repoLocation}/${dataset}"

        echo "Creating snapshot zroot/${dataset}@$SNAPNAME"
        ${pkgs.zfs}/bin/zfs snapshot "zroot/${dataset}@$SNAPNAME"

        echo "Cloning snapshot to zroot/$CLONE_NAME"
        ${pkgs.zfs}/bin/zfs clone -o mountpoint="$MOUNTPOINT" "zroot/${dataset}@$SNAPNAME" "zroot/$CLONE_NAME"
        ${pkgs.zfs}/bin/zfs list -t all | grep "$CLONE_NAME" || echo "DEBUG: clone not found"

        # Wait until dataset exists
        for i in {1..10}; do
          if zfs list -H -o name "zroot/$CLONE_NAME" >/dev/null 2>&1; then
            echo "Cloning finished!"
            break
          fi
          sleep 0.1
        done

        # Wait a moment for lazy mount to trigger
        sleep 0.2

        # Remount if directory is empty
        if [ -d "$MOUNTPOINT" ] && [ -z "$(ls -A "$MOUNTPOINT")" ]; then
          echo "Forcing remount of $DATASET as mountpoint is empty..."
          ${pkgs.zfs}/bin/zfs unmount "zroot/$CLONE_NAME" || true
          ${pkgs.zfs}/bin/zfs mount "zroot/$CLONE_NAME"
        fi

        if ! ${pkgs.zfs}/bin/zfs get -H -o value mounted "zroot/$CLONE_NAME" | grep -q "yes"; then
          echo "Mounting clone zroot/$CLONE_NAME to $MOUNTPOINT"
          ${pkgs.zfs}/bin/zfs mount "zroot/$CLONE_NAME"
        else
          echo "Clone zroot/$CLONE_NAME is already mounted"
        fi

      '')
      (
        lib.concatLists [
          cfg.zfs.datasets
          (lib.optionals (repoLocation == "local") [ "cache" ])
        ]
      );

  genCleanupCommands =
    repoLocation: snapshotPrefix:
    lib.concatMapStringsSep "\n"
      (dataset: ''
        SNAPNAME="${dataset}_${snapshotPrefix}"
        CLONE_NAME="backup-${dataset}-${snapshotPrefix}"
        MOUNTPOINT="/run/backup-mounts/${repoLocation}/${dataset}"

        echo "Unmounting $MOUNTPOINT"
        tries=5
        while ! ${pkgs.util-linux}/bin/umount "$MOUNTPOINT"; do
          if [ "$tries" -le 0 ]; then
            echo "Failed to unmount $MOUNTPOINT after retries, skipping."
            break
          fi
          echo "Unmounting $MOUNTPOINT failed, retrying..."
          sleep 1
          tries=$((tries - 1))
        done

        echo "Destroying clone zroot/$CLONE_NAME"
        ${pkgs.zfs}/bin/zfs destroy "zroot/$CLONE_NAME" || true

        echo "Destroying snapshot zroot/${dataset}@$SNAPNAME"
        ${pkgs.zfs}/bin/zfs destroy "zroot/${dataset}@$SNAPNAME" || true
      '')
      (
        lib.concatLists [
          cfg.zfs.datasets
          (lib.optionals (repoLocation == "local") [ "cache" ])
        ]
      );

  # Function to create a backup job for a specific repository
  mkBackupJob =
    repoLocation: repoUrl:
    mkIf (repoUrl != "none" && !cfg.prune.enable) {
      paths = [ "/run/backup-mounts/${repoLocation}" ];
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

      preHook = ''
        set -euxo pipefail

        LOCKFILE="/run/borgbackup-${repoLocation}.lock"
        exec 9>"$LOCKFILE"
        ${pkgs.util-linux}/bin/flock -n 9 || {
          echo "Another Borg job is running for ${repoLocation}, skipping."
          exit 0
        }

        SNAPSHOT_PREFIX="${generateSnapshotPrefix repoLocation}"
        printf "%s" "$SNAPSHOT_PREFIX" > "${prefixFile repoLocation}"

        mkdir -p "/run/backup-mounts/${repoLocation}"

        ${genDatasetCommands repoLocation "$SNAPSHOT_PREFIX"}
      '';

      postHook = ''
        set -euxo pipefail

        if [ ! -f "${prefixFile repoLocation}" ]; then
          echo "Missing prefix file, cannot clean up."
          exit 1
        fi

        SNAPSHOT_PREFIX="$(tr -d '\n\r' < /run/borgbackup-${repoLocation}.prefix)"
        rm -f "${prefixFile repoLocation}"

        ${genCleanupCommands repoLocation "$SNAPSHOT_PREFIX"}

        echo "Cleaning up mount base: /run/backup-mounts/${repoLocation}"
        if ! ${pkgs.util-linux}/bin/mount | grep -q "/run/backup-mounts/${repoLocation}"; then
          rm -rf "/run/backup-mounts/${repoLocation}"
        else
          echo "Still mounted, not removing /run/backup-mounts/${repoLocation}"
        fi
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
        wantedBy = [ "timers.target" ];
      }
    );

    systemd.services = lib.mkMerge [
      {
        init-borg-repos = {
          description = "Initialize Borg Repositories";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          environment = {
            BORG_PASSPHRASE_COMMAND = "cat ${config.sops.secrets."backup_${cfg.hostname}_passphrase".path}";
            BORG_RSH = "ssh -o StrictHostKeyChecking=accept-new -i ${
              config.sops.secrets."backup_${cfg.hostname}_key".path
            }";
            BORG_APPEND_ONLY = mkIf (!cfg.prune.enable) "1";
          };
        };
      }

      # Add per-job overrides here:
      (flip mapAttrs' config.services.borgbackup.jobs (
        name: _:
        nameValuePair "borgbackup-job-${name}" {
          serviceConfig = {
            RuntimeDirectory = "backup-mounts";
            RuntimeDirectoryMode = "0755";
            ReadWritePaths = [
              "/run/backup-mounts"
              "/run"
            ];
          };
        }
      ))
    ];
  };
}
