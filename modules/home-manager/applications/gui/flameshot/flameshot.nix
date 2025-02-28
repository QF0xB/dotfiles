{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.gui.flameshot;
in
{
  options.qnix.applications.gui.flameshot = with lib; {
    enable = mkEnableOption "flameshot screenshot utility" // {
      default = !config.qnix.headless;
    };
  };

  config = {
    home.packages = with pkgs; [ grim ];
    services.flameshot = {
      enable = cfg.enable;
      package = pkgs.flameshot.override { enableWlrSupport = true; };
      #      settings.General =
      #  let
      #    path = "${config.xdg.userDirs.pictures}/Screenhots/";
      #  in
      #  {
      #    savePath = path;
      #    saveAfterCopy = "true";
      #  };
    };
  };
}
