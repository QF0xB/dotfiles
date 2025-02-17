{
  options,
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.system.zfs;
in
{
  options.qnix.system.zfs = with lib; {
     encrypted = mkEnableOption "encrypted";
  };

  config = with lib; {
    boot.zfs = mkIf cfg.encrypted {
      requestEncryptionCredentials = true;
    };

    fileSystems = {
      # Root: will get reset.
      "/" = {
        device = "zroot/root";
        fsType = "zfs";
        neededForBoot = true;
      };

      # boot partition
      "/boot" = { 
        device = "/dev/disk/by-label/NIXBOOT"; 
        fsType = "vfat";  
      }; 
     
      # /nix 
      "/nix" = { 
        device = "zroot/nix"; 
        fsType = "zfs"; 
        neededForBoot = true; 
      }; 

      # /tmp to insure space isn't getting overfilled
      "/tmp" = { 
        device = "zroot/tmp"; 
        fsType = "zfs";  
      };

      # persisted storage
      "/persist" = { 
        device = "zroot/persist"; 
        fsType = "zfs"; 
        neededForBoot = true; 
      };

      # cache is persisted, but not snapshot.
      "/cache" = { 
        device = "zroot/cache"; 
        fsType = "zfs"; 
        neededForBoot = true; 
      };   
    };

    systemd.services = {
      # https://github.com/openzfs/zfs/issues/10891
      systemd-udev-settle.enable = false;
    };

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    # 16GB swap
    swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];

    boot.initrd.postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zroot/root@blank
      '';

    services.sanoid = {
      enable = true;

      datasets = {
        "zroot/persist" = {
          hourly = 50;
          daily = 15;
          weekly = 3;
          monthly = 1;
        };
      };
    };
  };
}
