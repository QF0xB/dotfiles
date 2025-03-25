{
  lib,
  config,
  isLaptop,
  pkgs,
  ...
}:

let
  cfg = config.qnix.system.screen;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.system.screen = {
    enable = mkEnableOption "screen control" // {
      default = isLaptop;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
    ];
  };
}
