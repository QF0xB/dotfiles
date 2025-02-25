{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.application.general.hyprsuite;
in
{
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];

  options.qnix.application.general.hyprsuite = with lib; {
    enable = mkOption {
      default = !(config.qnix.headless);
      description = "Activates the Default Hyprsuite.";
      type = types.bool;
    };
  };

  config.qnix.applications.general = lib.mkIf cfg.enable {
    hyprsuite = with lib; {
      hyprland.enable = mkDefault true;
      hyprlock.enable = mkDefault true;
      hyprpaper.enable = mkDefault true;
    };
  };
}
