{
  config,
  lib,
  pkgs,
  user,
  host,
  ...
}:

let
  homeDir = config.hm.home.homeDirectory;
  cfg = config.qnix.nix.sops;
  backup-cfg = config.hm.qnix.applications.security.backup;
  hostKey = "backup_${cfg.host}_key";
  hostPassphrase = "backup_${backup-cfg.hostname}_passphrase";
  hostKeyPrune = "backup_${backup-cfg.hostname}_key_prune";
in
{
  options.qnix.nix.sops = with lib; {
    enable = mkEnableOption "sops-nix secret management" // {
      default = true;
    };

    host = mkOption {
      type = types.str;
      description = "Which hosts secrets to unpack.";
      default = host;
    };

    backup-prune-keys.enable = mkEnableOption "decryption of backup-prune keys. DO NOT USE ON BACKUP DESKTOPS!";
  };

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../../../../secrets/default.yaml;

      age = {
        generateKey = false;
        keyFile = "/persist${homeDir}/.config/sops/age/keys.txt";
      };

      secrets =
        let
          secretSettings = {
            owner = "root";
            group = "root";
            mode = "0400";
          };
        in
        {
          ${hostKey} = secretSettings;
          ${hostPassphrase} = secretSettings;
        }
        // (
          if cfg.backup-prune-keys.enable then
            {
              ${hostKeyPrune} = {
                path = "${homeDir}/.ssh/backup_${cfg.host}";
                owner = config.users.users.${user}.name;
                group = "users";
                mode = "0400";
                sopsFile = ../../../../secrets/backup-prune-vm.yaml;
              };
            }
          else
            { }
        )
        // (
          if (host == "QFrame13") then
            {
              "eduroam" = {
                format = "binary";
                sopsFile = ../../../../secrets/eduroam_QFrame13_17_03_2025.p12;
              };
            }
          else
            { }
        );
    };
    users.users.${user}.extraGroups = [ config.users.groups.keys.name ];

    hm.qnix.applications.shells.packages = {
      install-remote-secrets = {
        runtimeInputs = [ pkgs.rsync ];
        text =
          let
            persistHome = "/persist${homeDir}";
            copy = src: ''rsync -aP --mkpath "${persistHome}/${src}" "$user@$remote:$target/${src}"'';
          in
          ''
            read -rp "Enter ip of remote host: " remote
            target="/mnt${persistHome}"

            while true; do
                read -rp "Use /mnt? [y/n] " yn
                case $yn in
                  [Yy]*)
                    echo "y";
                    target="/mnt${persistHome}"
                    break;;
                  [Nn]*)
                    echo "n";
                    target="${persistHome}"
                    break;;
                  *)
                    echo "Please answer yes or no.";;
                esac
            done

            read -rp "Enter user on remote host: [nixos] " user
            user=''${user:-nixos}

            ${copy ".ssh/"}
            ${copy ".config/sops/age/"}
          '';
      };
    };

    qnix.persist.home = {
      directories = [ ".config/sops" ];
    };
  };
}
