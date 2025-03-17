{
  config,
  lib,
  user,
  pkgs,
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
      networkmanager.enable = cfg.networkManager.enable;
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
      openssl
      iw
    ];
    users.users.${user}.extraGroups = [ "networkmanager" ];

    qnix.persist.root.directories = [ "/etc/easyroam-certs" ];
  };
}
