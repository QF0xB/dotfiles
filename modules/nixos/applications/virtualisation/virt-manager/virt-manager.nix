{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.qnix.applications.virtualisation.virt-manager;
  inherit (lib) mkIf;
in
{
  options.qnix.applications.virtualisation.virt-manager = with lib; {
    enable = mkEnableOption "VM support" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    boot = {
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

    hm.qnix.persist = {
      home.cache.directories = [
        "VMs"
      ];
    };
  };
}
