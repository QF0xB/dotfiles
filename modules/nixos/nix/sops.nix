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
in
{
  options.qnix.nix.sops = with lib; {
    enable = mkEnableOption "sops-nix secret management" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../../../secrets/default.yaml;

      age = {
        generateKey = false;
        keyFile = "/persist${homeDir}/.config/sops/age/keys.txt";
      };

      secrets = {
        "backup_${host}" = {
          path = "${homeDir}/.ssh/backup_${host}";
          owner = config.users.users.${user}.name;
          group = "users";
        };
      };
    };

    users.users.${user}.extraGroups = [ config.users.groups.keys.name ];

    qnix.system.shell.packages = {
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
