{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.system.security.polkit = {
    enable = mkEnableOption "polkit" // {
      default = true;
    };
  };
}
