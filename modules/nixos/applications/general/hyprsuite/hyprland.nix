{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.applications.general.hyprsuite.hyprland;
  inherit (lib) mkIf;
in
{
  options.qnix.applications.general.hyprsuite.hyprland = with lib; {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    programs = {
      hyprland = {
        enable = true;
      };
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
