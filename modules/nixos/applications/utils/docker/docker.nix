{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.hm.qnix.applications.utils.docker;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;

        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
  };
}
