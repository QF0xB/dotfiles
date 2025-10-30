{
  config,
  lib,
  ...
}:

let
  cfg = config.hm.qnix.applications.virtualisation.virtual-box;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    virtualisation.virtualbox = {
      host = {
        enable = true;
        # enableKvm = true;
        # addNetworkInterface = false;
      };
    };
  };
}
