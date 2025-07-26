{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hm.qnix.system.boot.grub;
  filesystem-config = config.hm.qnix.system.filesystem;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sbctl
    ];

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

      initrd = mkIf filesystem-config.luks-encrypted {
        luks.devices.cryptroot = {
          device = "/dev/disk/by-label/QNixRoot";
          preLVM = true;
          crypttabExtraOpts = [ "fido-device=auto" ];
        };
        systemd.enable = true;
      };
    };
  };
}
