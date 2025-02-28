{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.general.waybar;
in
{
  imports = [ ./assets/config.nix ];
  options.qnix.applications.general.waybar = with lib; {
    enable = mkEnableOption "waybar bar" // {
      default = config.qnix.applications.general.hyprsuite.hyprland.enable && !config.qnix.headless;
    };
    persistentWorkspaces = mkEnableOption "Persistent workspaces";
    hidden = mkEnableOption "Hidden waybar by default";
  };

  config = {
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      enable = cfg.enable;
      systemd.enable = true;
    };

    #xdg.configFile."waybar/config".source = ./assets/config;
    xdg.configFile."waybar/style.css".source = ./assets/style.css;
    xdg.configFile."waybar/waybar-yubikey" = {
      source = ./assets/waybar-yubikey;
      executable = true;
    };
  };
}
