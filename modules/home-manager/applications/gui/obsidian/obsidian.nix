{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.gui.obsidian;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.gui.obsidian = {
    enable = mkEnableOption "Obsidian note manager" // {
      default = !config.qnix.headless;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ obsidian ];

    qnix.persist.home = {
      directories = [
        "notes"
      ];
    };
  };
}
