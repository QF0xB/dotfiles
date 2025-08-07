{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hm.qnix.applications.desktop.xdg-portal;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;

        extraPortals =
          (lib.optionals cfg.wlr [ pkgs.xdg-desktop-portal-wlr ])
          ++ (lib.optionals cfg.gtk [ pkgs.xdg-desktop-portal-gtk ])
          ++ (lib.optionals cfg.gnome [ pkgs.xdg-desktop-portal-gnome ])
          ++ (lib.optionals cfg.hyprland [ pkgs.xdg-desktop-portal-hyprland ])
          ++ (lib.optionals cfg.xapp [ pkgs.xdg-desktop-portal-xapp ]);
      };
    };

    env.systemPackages = with pkgs; [ libsForQt5.xwaylandvideobridge ];
  };
}
