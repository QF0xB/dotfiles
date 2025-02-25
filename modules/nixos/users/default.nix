{
  lib,
  ...
}:

{
  imports = [
    ./default-user-config.nix
  ];

  config.qnix.users = with lib; {
    default-user.enable = mkDefault true;
  };
}
