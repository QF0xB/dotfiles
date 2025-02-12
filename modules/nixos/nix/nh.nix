{ 
  config, 
  pkgs, 
  user, 
  lib,
  ... 
}:

let
  cfg = config.qnix.nix.nh;
in
{
  options.qnix.nix.nh = with lib; {
    enable = mkEnableOption "nh cli-manager";
    clean.enable = mkEnableOption "nh cli-manager clean";
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
