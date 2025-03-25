{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.qnix.applications.audio.gui-utils;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.audio.gui-utils = {
    enable = mkEnableOption "command-line audio-gui-utils" // {
      default = config.qnix.applications.audio.pipewire.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pavucontrol
    ];
  };
}
