{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.general.swaync;
in
{
  options.qnix.applications.general.swaync = with lib; {
    enable = mkEnableOption "swaync notifications" // {
      default = !config.qnix.headless;
    };
  };

  config = {
    stylix.targets.swaync.enable = false;

    services.swaync = {
      enable = cfg.enable;

      style = ./assets/style.css;

      settings = {

        "$schema" = "/etc/xdg/swaync/configSchema.json";
        "positionX" = "right";
        "positionY" = "top";
        "control-center-margin-top" = 20;
        "control-center-margin-bottom" = 20;
        "control-center-margin-right" = 20;
        "control-center-margin-left" = 20;
        "notification-icon-size" = 48;
        "notification-body-image-height" = 100;
        "notification-body-image-width" = 200;
        "timeout" = 2;
        "timeout-low" = 1;
        "timeout-critical" = 0;
        "fit-to-screen" = true;
        "control-center-width" = 350;
        "notification-window-width" = 350;
        "keyboard-shortcuts" = true;
        "image-visibility" = "when-available";
        "transition-time" = 200;
        "hide-on-clear" = false;
        "hide-on-action" = true;
        "script-fail-notify" = true;
        "widgets" = [
          "title"
          "notifications"
          "volume"
          "backlight"
          "mpris"
        ];
        "widget-config" = {
          "title" = {
            "text" = "󰂚  :: Notifications";
            "clear-all-button" = true;
            "button-text" = "";
          };
          "dnd" = {
            "text" = "Do Not Disturb";
          };
          "label" = {
            "max-lines" = 1;
            "text" = "Notification Center";
          };
          "mpris" = {
            "image-size" = 50;
            "image-radius" = 10;
          };
          "volume" = {
            "label" = "";
            "show-per-app" = false;
          };
          "backlight" = {
            "label" = "";
            "subsystem" = "backlight";
            "device" = "acpi_video0";
          };
          "buttons-grid" = {
            "actions" = [
              {
                "label" = "󰔏";
                "command" = "hyprshade toggle redshift";
              }
              {
                "label" = "󰌵";
                "command" = "hyprshade toggle dim";
              }
              {
                "label" = "󰊠";
                "command" = "hyprshade toggle grayscale";
              }
              {
                "label" = "󰏘";
                "command" = "hyprshade toggle vibrance";
              }
              {
                "label" = "󰌁";
                "command" = "hyprshade toggle invert";
              }
            ];
          };
        };
      };
    };
  };
}
