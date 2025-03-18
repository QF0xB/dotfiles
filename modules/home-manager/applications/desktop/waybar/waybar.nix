{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.desktop.waybar;
  inherit (lib) mkEnableOption;
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
    persistentWorkspaces = mkEnableOption "Persistent workspaces";
    hidden = mkEnableOption "Hidden waybar by default";
  };

  config = {
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      enable = cfg.enable;
      systemd.enable = true;
    };

    xdg.configFile."waybar/waybar-yubikey" = {
      source = ./assets/waybar-yubikey;
      executable = true;
    };
  };
}
