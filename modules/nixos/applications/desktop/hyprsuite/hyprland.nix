{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hm.qnix.applications.desktop.hyprsuite;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.hyprland {
    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };
    };
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    # xdg.portal = {
    # enable = true;
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # };
  };
}
