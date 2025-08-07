{
  config,
  lib,
  ...
}:

let
  cfg = config.hm.qnix.applications.utils.upower;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    services.upower.enable = true;
  };
}
