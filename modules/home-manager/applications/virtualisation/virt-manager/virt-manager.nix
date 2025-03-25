{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.virtualisation.virt-manager = {
    enable = mkEnableOption "virt-manager";
    passthrough = mkEnableOption "vfio passthrough";
  };

  config = {
    qnix.persist.home = {
      cache.directories = [
        "VMs"
      ];
    };
  };
}
