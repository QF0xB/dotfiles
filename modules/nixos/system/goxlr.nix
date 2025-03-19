{
  lib,
  config,
  host,
  ...
}:

let
  cfg = config.qnix.system.goxlr;
  inherit (lib) mkEnableOption;
in
{
  options.qnix.system.goxlr = {
    enable = mkEnableOption "goxlr-utility" // {
      default = host == "QPC";
    };
  };

  config = {
    services.goxlr-utility.enable = cfg.enable;
  };
}
