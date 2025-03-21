{
  disko.devices = {
    disk = {
      x = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "64M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                
                settings = { 
                  allowDiscards = true;
                };
                
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "";
        # Workaround: cannot import 'zroot': I/O error in disko tests
        options = {
          cachefile = "none";
        };
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = "zfs snapshot zroot/root@blank";
            options = {
              mountpoint = "legacy";
            };
          };
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist"; 
            options = { 
              mountpoint = "legacy";
            };
          };
          cache = {
            type = "zfs_fs";
            mountpoint = "/cache"; 
            options = { 
              mountpoint = "legacy";
            };
          };
          tmp = {
            type = "zfs_fs";
            mountpoint = "/tmp"; 
            options = { 
              mountpoint = "legacy";
            };
          };
        };
      };
    };
  };
}
