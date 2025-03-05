{
  host,
  config,
  lib,
  ...
}:

{
  imports = [ ./backup-module.nix ];

  config = {
    qnix.system.backup = {
      enable = true;
      hostname = host;

      repositories."${host}" = {
        eu = "ssh://zv823m7n@zv823m7n.repo.borgbase.com/./repo";
        na = "ssh://zh0702n6@zh0702n6.repo.borgbase.com/./repo";
      };

      zfs = {
        enable = true;

        datasets = [ "zroot/root" ];
      };
    };
  };
}
