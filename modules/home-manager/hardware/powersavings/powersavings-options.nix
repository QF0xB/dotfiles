{
  lib,
  isLaptop,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.hardware.powersavings = {
    enable = mkEnableOption "powersavings" // {
      default = isLaptop;
    };
  };
}
