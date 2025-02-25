{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.general.hyprsuite.hyprlock;
in
{
  options.qnix.applications.general.hyprsuite.hyprlock = with lib; {
    enable = mkEnableOption "hyprlock";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
    };
  };
}
