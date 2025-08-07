{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.utils.upower = {
    enable = mkEnableOption "upower" // {
      default = !config.qnix.headless;
    };
  };
}
