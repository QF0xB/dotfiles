{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.tui.direnv;
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.tui.direnv = {
    enable = mkEnableOption "direnv" // {
      default = true;
    };
  };

  config = {
    programs = {
      direnv = {
        enable = cfg.enable;
        nix-direnv.enable = true;
      };
    };
  };
}
