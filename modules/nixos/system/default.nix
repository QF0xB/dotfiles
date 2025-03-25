{
  lib,
  ...
}:

{
  imports = [
    ./boot
    ./environment
    ./localisation
    ./networking/networking.nix
    ./packages.nix
    ./ssh-server
    ./zfs
  ];
}
