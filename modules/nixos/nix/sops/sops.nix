{
  config,
  lib,
  user,
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
    # nix.settings.access-tokens = [
    # "github.com=!include ${config.sops.secrets.github_token.path}"
    # "api.github.com=!include ${config.sops.secrets.github_token.path}"
    # ];

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
          github_token = {
            key = "github_token";
            owner = "root";
            group = "nixbld";
            mode = "0777";
          };
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
        );
    };
    users.users.${user}.extraGroups = [ config.users.groups.keys.name ];

    qnix.persist.home = {
      directories = [ ".config/sops" ];
    };
  };
}
