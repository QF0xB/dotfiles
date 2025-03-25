{
  lib,
  config,
  ...
}:

let
  cfg = config.hm.qnix.system.boot.grub;
in
{
  config = lib.mkIf cfg.enable {
    boot = {
      supportedFilesystems = {
        zfs = true;
        ntfs = true;
      };

      loader = {
        efi.efiSysMountPoint = "/boot";
        efi.canTouchEfiVariables = true;

        grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          zfsSupport = true;
          enableCryptodisk = true;
        };

        timeout = 3;
      };

      initrd.luks.devices.cryptroot = {
        device = "/dev/disk/by-label/QNixRoot";
        preLVM = true;
      };
    };
  };
}
