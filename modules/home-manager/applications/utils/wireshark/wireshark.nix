{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.applications.utils.wireshark;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.utils.wireshark = {
    enable = mkEnableOption "wireshark" // {
      default = true;
    };
  };
}
