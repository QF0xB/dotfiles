{
  options, 
  lib,
  config,
  isVm,
  ... 
}:

let
  cfg = config.qnix.system.boot;
in
{
  options.qnix = with lib; {
    system.boot.enable = mkEnableOption "systemd-boot";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      supportedFilesystems.zfs = true;

      loader = { 
        efi.efiSysMountPoint = "/boot";
        efi.canTouchEfiVariables = true;
        
        grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          zfsSupport = true;
        };
        timeout = 3;
      };
      zfs = {
        devNodes =
            if isVm then
              "/dev/disk/by-partuuid"
            # use by-id for intel mobo when not in a vm
            else if config.hardware.cpu.intel.updateMicrocode then
              "/dev/disk/by-id"
            else
              "/dev/disk/by-partuuid";
      };
    };
  };
}
