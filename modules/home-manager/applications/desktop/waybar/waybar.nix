{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.desktop.waybar;
  inherit (lib) mkEnableOption mkOption types;
in
{
  imports = [
    ./assets/config.nix
    ./assets/style.nix
  ];

  options.qnix.applications.desktop.waybar = {
    enable = mkEnableOption "waybar bar" // {
      default = config.qnix.applications.desktop.hyprsuite.hyprland;
    };

    displays = {
      large = mkOption {
        description = "Large Waybar displays.";
        type = types.listOf types.str;
        default = [ ];
        example = [ "eDP-0" ];
      };

      small = mkOption {
        description = "Small Waybar displays.";
        type = types.listOf types.str;
        default = [ ];
        example = [ "HDMI-0-1" ];
      };
    };

    persistentWorkspaces = mkEnableOption "Persistent workspaces";
    hidden = mkEnableOption "Hidden waybar by default";
  };

  config = {
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      inherit (cfg) enable;
      systemd.enable = true;
    };

    xdg.configFile."waybar/waybar-yubikey" = {
      source = ./assets/waybar-yubikey;
      executable = true;
    };
  };
}
