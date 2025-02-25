{
  lib,
  config,
  ...
}:

let
  cfg = config.hm.qnix.applications.general.hyprsuite;
in
{
  imports = [
    ./hyprland.nix
  ];

  config.qnix.applications.general = lib.mkIf cfg.enable {
  };
}
