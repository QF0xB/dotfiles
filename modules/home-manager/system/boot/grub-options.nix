{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.qnix.system.boot.grub;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.system.boot.grub = {
    enable = mkEnableOption "grub" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    qnix.applications.shells.packages = {
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
