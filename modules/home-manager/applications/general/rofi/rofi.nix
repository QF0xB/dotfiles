{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.general.rofi;
in
{
  options.qnix.applications.general.rofi = with lib; {
    enable = mkEnableOption "rofi";

    launcher.theme = {
      enable = mkOption {
        default = true;
        type = types.bool;
        description = "Enable rofi-allthemes";
      };
      type = mkOption {
        default = "1";
        type = types.str;
        description = "rofi themetype";
      };
      style = mkOption {
        default = "9";
        type = types.str;
        description = "rofi themestyle";
      };
    };
  };

  config = {
    programs.rofi = {
      enable = cfg.enable;
      package = pkgs.rofi-wayland;
      #theme = "~/.config/rofi/launchers/type-${cfg.launcher.theme.type}/style-${cfg.launcher.theme.style}.rasi";
    };

    programs.qnix.rofi-allthemes = {
      enable = true;
      colorScheme = "solarized"; # Choose your preferred color scheme
    };

    stylix.targets.rofi.enable = !cfg.launcher.theme.enable;
  };
}
