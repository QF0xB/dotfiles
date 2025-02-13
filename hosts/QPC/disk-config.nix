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
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
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
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
#              keylocation = "file:///tmp/secret.key";
            };
          };
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist"; 
            options = { 
              mountpoint = "legacy";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
#              keylocation = "file:///tmp/secret.key";
            };
          };
          cache = {
            type = "zfs_fs";
            mountpoint = "/cache"; 
            options = { 
              mountpoint = "legacy";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
#              keylocation = "file:///tmp/secret.key";
            };
          };
          tmp = {
            type = "zfs_fs";
            mountpoint = "/tmp"; 
            options = { 
              mountpoint = "legacy";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
#              keylocation = "file:///tmp/secret.key";
            };
          };
        };
      };
    };
  };
}
