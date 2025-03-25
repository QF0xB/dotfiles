{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.applications.editors.helix;
  inherit (lib) mkIf;
in
{
  options.qnix.applications.editors.helix = with lib; {
    enable = mkEnableOption "Helix editor"; # Not using anymore
  };

  config = mkIf cfg.enable {
    programs = {

      helix = {
        enable = true;
      };
    };
  };
}
