{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.editors.obsidian;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.editors.obsidian = {
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
