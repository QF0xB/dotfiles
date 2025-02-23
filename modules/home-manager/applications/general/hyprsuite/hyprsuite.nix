{
  options, 
  config,
  ...
}:

{ 
  imports = [
    ./hyprland.nix
  ];

  config.qnix.home.applications.general.hyprsuite = {
    hyprland.enable = true;
  };
}
