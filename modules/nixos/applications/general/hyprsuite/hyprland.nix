{
  config,
  lib,
  pkgs,
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
        withUWSM = true;
      };
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
