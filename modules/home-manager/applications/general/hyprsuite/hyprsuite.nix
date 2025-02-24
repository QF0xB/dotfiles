{
  options,
  config,
  lib,
  ...
}:

{
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];

  config.qnix.home.applications.general.hyprsuite = with lib; {
    hyprland.enable = mkDefault true;
    hyprlock.enable = mkDefault true;
    hyprpaper.enable = mkDefault true;
  };
}
