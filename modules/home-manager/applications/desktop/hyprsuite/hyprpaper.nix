{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.desktop.hyprsuite;
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.desktop.hyprsuite = {
    hyprpaper = mkEnableOption "hyprpaper";
  };

  config = lib.mkIf cfg.hyprpaper {
    services.hyprpaper = {
      enable = true;
      # Wallpaper manager by stylix nixos-module
    };
  };
}
