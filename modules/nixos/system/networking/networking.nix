{
  config,
  lib,
  user,
  pkgs,
  isLaptop,
  ...
}:

let
  cfg = config.qnix.system.networking;
  inherit (lib) mkEnableOption mkIf;
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
      firewall.enable = false;
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
      openssl
      iw
      qnix-pkgs.easyroam-setup
      openvpn
    ];
    users.users.${user}.extraGroups = [ "networkmanager" ];

    systemd = mkIf isLaptop {
      services.easyroam-setup = {
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
    };

    qnix.persist.root.directories = [
      "/etc/easyroam-certs"
      "/etc/vpn-certs"
    ];

  };
}
