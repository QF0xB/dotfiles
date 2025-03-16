{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.system.boot;
in
{
  options.qnix = with lib; {
    system.boot.grub.enable = mkEnableOption "grub";
  };

  config = lib.mkIf cfg.grub.enable {
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
    qnix.system.shell.packages = {
      reboot-to-windows = {
        runtimeInputs = [ pkgs.grub2 ];
        text = # sh
          ''
            sudo grub-reboot "Windows 11"
            sudo reboot
          '';
      };
    };
  };
}
