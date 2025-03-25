{
  config,
  ...
}:

let
  cfg = config.hm.qnix.applications.audio.goxlr-utility;
in
{
  config = {
    services.goxlr-utility.enable = cfg.enable;
  };
}
