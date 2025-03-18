{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hm.qnix.applications.desktop.xdg-portal;
  inherit (lib) concatLists mkIf;
in
{
  config = mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;
        config.common.default = "*";
        extraPortals =
          with pkgs;
          with lists;
          concatLists (
            (optionals cfg.wlr [ xdg-desktop-portal-wlr ]) (optionals cfg.gtk [ xdg-desktop-portal-gtk ])
              (optionals cfg.gnome [ xdg-desktop-portal-gnome ])
              (optionals cfg.hyprland [ xdg-desktop-portal-hyprland ])
              (optionals cfg.xapp [ xdg-desktop-portal-xapp ])
          );
      };
    };

    env.systemPackages = with pkgs; [ libsForQt5.xwaylandvideobridge ];
  };
}
