{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.qnix.applications.audio.utils;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.audio.utils = {
    enable = mkEnableOption "command-line audio-utils" // {
      default = config.qnix.applications.audio.pipewire.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pamixer
    ];
  };
}
