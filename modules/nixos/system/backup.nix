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
        eu = {
          label = "eu";
          path = "ssh://isn6p3y0@isn6p3y0.repo.borgbase.com/./repo";
        };
        na = {
          label = "na";
          path = "ssh://cn0b5a18@cn0b5a18.repo.borgbase.com/./repo";
        };
        as = {

        };
        au = {

        };
      };

      zfs = {
        enable = true;

        datasets = [ "zroot/root" ];
      };
    };
  };
}
