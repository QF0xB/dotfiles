{
  config,
  lib,
  user,
  host,
  ...
}:

let
  inherit (lib) mkIf;
  homeDir = config.hm.home.homeDirectory;
  cfg = config.hm.qnix.nix.sops;
  backup-cfg = config.hm.qnix.applications.security.backup;
  hostKey = "backup_${cfg.host}_key";
  hostPassphrase = "backup_${backup-cfg.hostname}_passphrase";
  hostKeyPrune = "backup_${backup-cfg.hostname}_key_prune";
in
{
  config = mkIf cfg.enable {
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

    qnix.persist.home = {
      directories = [ ".config/sops" ];
    };
  };
}
