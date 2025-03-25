{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hm.qnix.applications.work.teamviewer;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    services.teamviewer = {
      enable = true;
      package = pkgs.teamviewer;
    };
  };
}
