{
  lib,
  isLaptop,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.hardware.bluetooth = {
    enable = mkEnableOption "bluetooth" // {
      default = isLaptop;
    };
  };
}
