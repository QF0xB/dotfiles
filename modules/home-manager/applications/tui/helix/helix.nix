{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.applications.tui.helix;
  inherit (lib) mkIf;
in
{
  options.qnix.applications.tui.helix = with lib; {
    enable = mkEnableOption "Helix editor";
  };

  config = mkIf cfg.enable {
    programs = {

      helix = {
        enable = true;
      };
    };
  };
}
