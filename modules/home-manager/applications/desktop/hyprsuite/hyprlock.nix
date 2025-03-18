{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.desktop.hyprsuite;
in
{
  options.qnix.applications.desktop.hyprsuite = with lib; {
    hyprlock = mkEnableOption "hyprlock";
  };

  config = lib.mkIf cfg.hyprlock {
    programs.hyprlock = {
      enable = true;
    };
  };
}
