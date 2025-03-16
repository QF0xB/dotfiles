{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.nix;
in
{
  imports = [
    ./general/hyprsuite/hyprsuite.nix
    ./general/sddm/sddm.nix
    ./gui/chromium/chromium.nix
    ./virtualisation/virt-manager/virt-manager.nix
  ];
}
