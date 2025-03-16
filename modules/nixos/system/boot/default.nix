{
  lib,
  ...
}:

{
  imports = [
    ./grub.nix
    ./systemd-boot.nix
    ./windows.nix
  ];

  # CONFIG IN ../default.nix
}
