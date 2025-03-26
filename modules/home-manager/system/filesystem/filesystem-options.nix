{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.system.filesystem = {
    luks-encrypted = mkEnableOption "encryption" // {
      default = true;
    };
  };
}
