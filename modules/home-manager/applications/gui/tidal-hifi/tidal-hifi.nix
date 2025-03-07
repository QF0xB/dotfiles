{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.gui.tidal-hifi;
in
{
  options.qnix.applications.gui.tidal-hifi = with lib; {
    enable = mkEnableOption "tidal-hifi music client" // {
      default = !config.qnix.headless;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ tidal-hifi ];

    qnix.persist.home = {
      directories = [ "tidal-hifi" ];
    };
  };
}
