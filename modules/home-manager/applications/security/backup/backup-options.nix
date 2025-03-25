{
  lib,
  host,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.qnix.applications.security.backup;

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

in
{
  options.qnix.applications.security.backup = {
    enable = mkEnableOption "backup" // {
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

  config =
    let
      cfg = config.qnix.applications.security.backup;
      repos = {
        QPC = {
          local = "ssh://q.braendliBACKUP@10.0.1.15/share/QBackup/QPC";
          eu = "ssh://lh4w8o74@lh4w8o74.repo.borgbase.com/./repo";
          us = "ssh://r07bi749@r07bi749.repo.borgbase.com/./repo";
          as = "none";
          au = "none";
        };
        QFrame13 = {
          local = "ssh://q.braendlBACKUP@10.0.1.15/share/QBackup/QFrame13";
          eu = "ssh://zv823m7n@zv823m7n.repo.borgbase.com/./repo";
          us = "ssh://zh0702n6@zh0702n6.repo.borgbase.com/./repo";
          as = "none";
          au = "none";
        };
      };
    in
    {
      qnix.applications.security.backup = {
        enable = true;

        repositories.${cfg.hostname} = repos.${cfg.hostname} or { };

        zfs = {
          enable = true;

          datasets = [ "persist" ];
        };
      };
    };
}
