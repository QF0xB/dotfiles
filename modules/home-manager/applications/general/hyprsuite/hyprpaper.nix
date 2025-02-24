{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.home.applications.general.hyprsuite.hyprpaper;
in
{
  options.qnix.home.applications.general.hyprsuite.hyprpaper = with lib; {
    enable = mkEnableOption "hyprpaper";
    wallpaper = mkOption {
      default = "$HOME/.config/hypr/wallpaper/main-wallpaper.png";
      type = types.str;
      description = "Filepath of wallpaper.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = cfg.wallpaper;
        wallpaper = ", ${cfg.wallpaper}";
      };
    };

    home.file.".config/hypr/wallpaper/main-wallpaper.png" = {
      enable = true;
      source = builtins.toString ./wallpapers/main-wallpaper.png;
    };
  };
}
