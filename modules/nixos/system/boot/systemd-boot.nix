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
    # Change the option name to reflect systemd-boot instead of GRUB.
    system.boot.systemd-boot.enable = mkEnableOption "systemd-boot";
  };

  config = lib.mkIf cfg.systemd-boot.enable {
    boot = {
      supportedFilesystems.zfs = true;

      loader = { 
        # Enable systemd-boot directly
        systemd-boot.enable = true;
        efi.efiSysMountPoint = "/boot";
        efi.canTouchEfiVariables = true;
        timeout = 3;
      };

      zfs = {
        devNodes =
          if isVm then "/dev/disk/by-partuuid"
          else if config.hardware.cpu.intel.updateMicrocode then "/dev/disk/by-id"
          else "/dev/disk/by-partuuid";
      };
    };
  };
}
