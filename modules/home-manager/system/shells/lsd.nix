{
  config,
  options,
  lib,
  ...
}:

let
  cfg = config.qnix.home.system.shell.lsd;
in
{
  options.qnix.home.system.shell.lsd = with lib; {
    enable = mkEnableOption "lsd - better ls command" // {
      default = true;
    };
  };

  config = {
    programs.lsd = {
      enable = cfg.enable;
    };
  };
}
