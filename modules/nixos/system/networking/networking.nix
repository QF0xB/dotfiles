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
      qnix-pkgs.easyroam-setup
    ];
    users.users.${user}.extraGroups = [ "networkmanager" ];

    systemd.services.easyroam-setup = {
      description = "EasyRoam Setup";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        Restart = "no";
        path = with pkgs; [
          openssl
          gawk
          coreutils
          networkmanager
          iw
        ];
      };

      script = ''
        ${pkgs.qnix-pkgs.easyroam-setup}/bin/easyroam-setup
      '';
    };

    qnix.persist.root.directories = [ "/etc/easyroam-certs" ];
  };
}
