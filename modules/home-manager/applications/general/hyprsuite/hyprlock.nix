{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.home.applications.general.hyprsuite.hyprlock;
in
{
  options.qnix.home.applications.general.hyprsuite.hyprlock = with lib; {
    enable = mkEnableOption "hyprlock";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
    };
  };
}
