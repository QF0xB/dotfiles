{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.editors.direnv;
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.editors.direnv = {
    enable = mkEnableOption "direnv" // {
      default = config.qnix.development;
    };
  };

  config = {
    programs = {
      direnv = {
        inherit (cfg) enable;
        nix-direnv.enable = true;
      };
    };
  };
}
