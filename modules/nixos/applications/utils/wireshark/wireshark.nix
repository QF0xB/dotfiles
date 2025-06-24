{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hm.qnix.applications.utils.wireshark;
  inherit (lib) mkEnableOption mkIf;
in
{
  config = mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
