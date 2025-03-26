{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hm.qnix.hardware.screen;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
    ];
  };
}
