{
  config,
  lib, 
  isLaptop,
  ...
}: 

let
  cfg = config.qnix.system.powersavings;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.qnix.system.powersavings = { 
    enable = mkEnableOption "Laptop Powersavings" // {
      default = isLaptop;
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.wifi.powersave = true;
    powerManagement.enable = true;

    services.tlp = {
      enable = true;

      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;
      };
    };
  };
}
