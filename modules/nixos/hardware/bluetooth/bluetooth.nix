{
  config,
  lib,
  ...
}:

let
  cfg = config.hm.qnix.hardware.bluetooth;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
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
