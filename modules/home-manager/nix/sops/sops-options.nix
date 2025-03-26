{
  lib,
  host,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.nix.sops;
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  homeDir = config.home.homeDirectory;
in
{
  options.qnix.nix.sops = {
    enable = mkEnableOption "sops" // {
      default = true;
    };

    host = mkOption {
      type = types.str;
      description = "Which hosts secrets to unpack.";
      default = host;
    };

    backup-prune-keys.enable = mkEnableOption "decryption of backup-prune keys. DO NOT USE ON BACKUP DESKTOPS!";
  };

  config = mkIf cfg.enable {
    qnix.applications.shells.packages = {
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

  };
}
