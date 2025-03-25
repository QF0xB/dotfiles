{
  config,
  lib,
  user,
  host,
  ...
}:

let
  cfg = config.hm.qnix.applications.virtualisation.virt-manager;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    boot = mkIf cfg.passthrough {
      initrd = {
        availableKernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ];
      };

      kernelParams = [
        "intel_iommu=on"
      ];
    };

    users.users.${user}.extraGroups = [ "libvirtd" ];

    qnix.persist = {
      root = {
        directories = [ "/var/lib/libvirt" ];
        cache.directories = [ "/var/lib/libvirtd" ];
      };
    };
  };
}
