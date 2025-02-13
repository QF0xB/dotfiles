{
  options, 
  lib,
  config,
  ... 
}:

let
  cfg = config.qnix.system.boot.systemd-boot;
in
{
  options.qnix = with lib; {
    system.boot.systemd-boot.enable = mkEnableOption "systemd-boot";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      supportedFilesystems.zfs = true;

      loader = { 
        efi.efiSysMountPoint = "/boot";

        grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
        };
        timeout = 3;
      };  
    };

    zfs = {
      devNodes = "/dev/disk/by-id";
      requestEncryptionCredentials = true;
    };
  };
}
