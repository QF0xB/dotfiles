{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.virtualisation.virtual-box = {
    enable = mkEnableOption "virtual-box" // {
      default = false;
    };
  };
}
