{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.gui.teamviewer;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.qnix.applications.gui.teamviewer = {
    enable = mkEnableOption "teamviewer" // {
      default = !config.hm.qnix.headless;
    };
  };

  config = mkIf cfg.enable {
    services.teamviewer = {
      enable = true;
      package = pkgs.stable.teamviewer;
    };
  };
}
