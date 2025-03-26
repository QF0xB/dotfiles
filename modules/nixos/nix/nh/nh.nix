{
  config,
  lib,
  ...
}:

let
  cfg = config.hm.qnix.nix.nh;
  inherit (lib) mkIf;
in
{
  config = {
    programs.nh = {
      inherit (cfg) enable;

      clean = mkIf cfg.clean.enable {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };
  };
}
