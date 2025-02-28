{
  host,
  config,
  lib,
  ...
}:

{
  config = {
    home.file.".ssh/backup_${host}" = {
      enable = true;
      text = builtins.toJSON (builtins.attrNames config.sops.secrets);
      #source = lib.mkAfter config.sops.secrets."backup_${host}".path;
    };
  };
}
