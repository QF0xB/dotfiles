{
  config,
  lib,
  isLaptop,
  ...
}:

let
  cfg = config.qnix.system.bluetooth;
in
{
  options.qnix.system.bluetooth = with lib; {
    enable = mkEnableOption "Bluetooth" // {
      default = isLaptop;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;

    qnix.persist = {
      root.directories = [ "/var/lib/bluetooth" ];
    };
  };
}
