{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.qnix.applications.utils.screenshot;
in
{
  options.qnix.applications.utils.screenshot = {
    enable = mkEnableOption "Screenshot commands " // {
      default = !config.qnix.headless;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard
      libnotify
    ];
  };
}
