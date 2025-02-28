{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.gui.webcord;
in
{
  options.qnix.applications.gui.webcord = with lib; {
    enable = mkEnableOption "activate webcord" // {
      default = !config.qnix.headless;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ webcord ];

    qnix.persist.home.directories = [
      "WebCord"
    ];
  };
}
