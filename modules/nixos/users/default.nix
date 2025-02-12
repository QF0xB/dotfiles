{
  lib,
  config,
  ...
}:

{
  imports = [
    ./lcqbraendli.nix   
  ];

  config.qnix.users = with lib; {
    lcqbraendli.enable = mkDefault true;
  };
}
