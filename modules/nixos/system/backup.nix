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
        eu = "ssh://isn6p3y0@isn6p3y0.repo.borgbase.com/./repo";
        na = "ssh://cn0b5a18@cn0b5a18.repo.borgbase.com/./repo";
      };

      zfs = {
        enable = true;

        datasets = [ "zroot/root" ];
      };
    };
  };
}
