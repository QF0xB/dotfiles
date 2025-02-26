{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.general.hyprsuite.hyprpaper;
in
{
  options.qnix.applications.general.hyprsuite.hyprpaper = with lib; {
    enable = mkEnableOption "hyprpaper";
  };

  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      # Wallpaper manager by stylix nixos-module
    };
  };
}
