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
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
