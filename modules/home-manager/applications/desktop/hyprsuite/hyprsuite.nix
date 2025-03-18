{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.applications.desktop.hyprsuite;
  inherit (lib) mkOption types;
in
{
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];

  options.qnix.applications.desktop.hyprsuite = {
    enable = mkOption {
      default = !(config.qnix.headless);
      description = "Activates the Default Hyprsuite.";
      type = types.bool;
    };
  };

  config.qnix.applications.desktop.hyprsuite = {
    hyprland = cfg.enable;
    hyprpaper = cfg.enable;
    hyprlock = cfg.enable;
  };
}
