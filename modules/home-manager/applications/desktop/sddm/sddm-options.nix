{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.desktop.sddm = {
    enable = mkEnableOption "sddm login manager" // {
      default = !config.qnix.headless;
    };
  };
}
