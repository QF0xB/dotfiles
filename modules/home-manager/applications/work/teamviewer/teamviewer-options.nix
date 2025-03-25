{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.work.teamviewer = {
    enable = mkEnableOption "teamviewer remote desktop" // {
      default = config.qnix.work;
    };
  };
}
