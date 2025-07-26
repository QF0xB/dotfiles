{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption;
  cfg = config.qnix.system.boot.secure-boot;
in
{
  options.qnix.system.boot.secure-boot = {
    enable = mkEnableOption "secure-boot" // {
      default = false; # Broken at this point in time. Not necessary anyway though
    };
  };
}
