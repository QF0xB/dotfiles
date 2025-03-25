{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.system.boot.windows = {
    enable  = mkEnableOption "windows" // {
      default = false;
    };
  };
}
