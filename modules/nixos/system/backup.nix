{
  config,
  lib,
  ...
}:

{
  imports = [ ./backup-module.nix ];

  config =
    let
      cfg = config.qnix.system.backup;
    in
    {
      qnix.system.backup = {
        enable = true;

        repositories."${cfg.hostname}" = {
          eu = "${config.sops.secrets."backup_${cfg.hostname}_eu".text}";
          us = "${config.sops.secrets."backup_${cfg.hostname}_us".text}";
          as = "${config.sops.secrets."backup_${cfg.hostname}_as".text}";
          au = "${config.sops.secrets."backup_${cfg.hostname}_au".text}";
        };

        zfs = {
          enable = true;

          datasets = [ "zroot/root" ];
        };
      };
    };
}
