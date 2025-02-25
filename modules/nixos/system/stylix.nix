{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.system.stylix;
in
{
  options.qnix.system.stylix = with lib; {
    enable = mkEnableOption "global styling with stylix";
  };

  config = {
    stylix.enable = cfg.enable;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
  };
}
