{
  config,
  lib,
  user,
  pkgs,
  isLaptop,
  host,
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
      networkmanager = {
        enable = cfg.networkManager.enable;
        unmanaged = if (host == "QPC") then [ "enp6s0" ] else [ ];
      };

      firewall.enable = false;

      interfaces = mkIf (host == "QPC") {
        enp6s0 = {
          useDHCP = false;
          ipv4.addresses = [ ];
          ipv6.addresses = [ ];
        };
      };
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
