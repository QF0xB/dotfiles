{
  lib,
  ...
}:

{
  imports = [
    ./grub.nix
    ./systemd-boot.nix
  ];

  # CONFIG IN ../default.nix
}
