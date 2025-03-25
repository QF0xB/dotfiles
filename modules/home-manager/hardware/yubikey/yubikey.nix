{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.hardware.yubikey = {
    enable = mkEnableOption "yubikey support" // {
      default = true;
    };
  };
}
