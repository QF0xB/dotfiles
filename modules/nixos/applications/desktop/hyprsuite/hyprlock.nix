{
  config,
  lib,
  ...
}:

let
  cfg = config.hm.qnix.applications.desktop.hyprsuite.hyprlock;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg {
    security.pam.services.hyprlock = { };
  };
}
