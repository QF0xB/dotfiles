{
  config, 
  lib,
  user, 
  ...
}: 

let 
  cfg = config.qnix.system.networking;
  inherit (lib) mkEnableOption;
in
{
  options.qnix.system.networking = {
    networkManager.enable = mkEnableOption "networkManager" // {
      default = true;
    };
  };

  config = {
    networking = {
      networkmanager.enable = cfg.enable;
    };

    users.users.${user}.extraGroups = [ "networkmanager" ];
  };
}
