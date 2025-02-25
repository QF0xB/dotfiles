{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hm.qnix.applications.general.hyprsuite;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.hyprland.enable {
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
