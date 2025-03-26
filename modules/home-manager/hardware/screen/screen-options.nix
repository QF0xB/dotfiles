{
  lib,
  isLaptop,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.hardware.screen = {
    enable = mkEnableOption "screen" // {
      default = isLaptop;
    };
  };
}
