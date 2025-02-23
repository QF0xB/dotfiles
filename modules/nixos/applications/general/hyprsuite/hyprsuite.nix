{
  lib,
  config,
  ...
}:

{
  imports = [
    ./hyprland.nix 
  ];

  config.qnix.applications.general.hyprsuite = with lib; {
    hyprland.enable = true;
  };
}
