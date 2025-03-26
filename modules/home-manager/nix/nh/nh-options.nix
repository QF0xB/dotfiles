{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.nix.nh = {
    enable = mkEnableOption "nh" // {
      default = true;
    };

    clean.enable = mkEnableOption "nh auto-clean" // {
      default = true;
    };
  };
}
