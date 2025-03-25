{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.nix.nh;
in
{
  options.qnix.nix.nh = with lib; {
    enable = mkEnableOption "nh cli-manager" // {
      default = true;
    };
    clean.enable = mkEnableOption "nh cli-manager clean" // {
      default = true;
    };
  };

  config = with lib; {
    programs.nh = {
      enable = cfg.enable;
      clean = mkIf cfg.clean.enable {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };
  };
}
