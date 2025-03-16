{
  config,
  lib,
  host,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf concatLines;
  cfg = config.qnix.system.boot.windows;
in
{
  options.qnix.system.boot.windows = {
    enable = mkEnableOption "Windows dual boot" // {
      default = host == "QPC";
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {
      grub = mkIf config.qnix.system.boot.grub.enable {
        extraEntries = ''
          menuentry "Windows 11" {
            insmod part_gpt
            insmod fat
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root B012-5B2E 
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
    };
  };
}
