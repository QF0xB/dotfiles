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
    programs.uwsm.enable = true;
    environment = {
      etc."xdg/wayland-sessions/hyprland-uwsm.desktop".text = ''
        [Desktop Entry]
        Name=Hyprland (uwsm)
        Exec=uwsm start hyprland
        Type=Application
      '';
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
