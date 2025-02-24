{
  config,
  lib,
  pkgs,
  user,
  ...
}:

let
  homeDir = config.hm.home.homeDirectory;
in
{
  options.qnix = with lib; {
    nix.sops.enable = mkEnableOption "sops";
  };

  config = lib.mkIf config.qnix.nix.sops.enable {
    sops = {
      defaultSopsFile = ../../../secrets/default.yaml;

      age = {
        generateKey = false;
        keyFile = "/persist${homeDir}/.config/sops/age/keys.txt";
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
