{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.system.boot.systemd-boot = {
    enable = mkEnableOption "systemd-boot.nix" // {
      default = false;
    };
  };
}
