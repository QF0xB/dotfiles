{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.desktop.xdg-portal = {
    enable = mkEnableOption "xdg-portal enabled" // {
      default = config.qnix.wayland;
    };

    gtk = mkEnableOption "extra gtk portal" // {
      default = true;
    };

    gnome = mkEnableOption "extra gnome portal" // {
      default = false;
    };

    wlr = mkEnableOption "extra wlr portal" // {
      default = false;
    };

    hyprland = mkEnableOption "extra hyprland portal" // {
      default = config.qnix.applications.desktop.hyprsuite.hyprland;
    };

    xapp = mkEnableOption "extra xapp portal" // {
      default = false;
    };
  };
}
