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
      repos = {
        QPC = {
          eu = "ssh://lh4w8o74@lh4w8o74.repo.borgbase.com/./repo";
          us = "ssh://r07bi749@r07bi749.repo.borgbase.com/./repo";
          as = "dont-use";
          au = "dont-use";
        };
        QFrame13 = {
          eu = "ssh://zv823m7n@zv823m7n.repo.borgbase.com/./repo";
          us = "ssh://zh0702n6@zh0702n6.repo.borgbase.com/./repo";
          as = "dont-use";
          au = "dont-use";
        };
      };
    in
    {
      qnix.system.backup = {
        enable = true;

        repositories.${cfg.hostname} = repos.${cfg.hostname} or { };

        zfs = {
          enable = true;

          datasets = [ "zroot/root" ];
        };
      };
    };
}
