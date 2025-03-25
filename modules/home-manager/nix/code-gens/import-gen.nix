{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.qnix.nix.code-gen.import-gen;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.nix.code-gen.import-gen = {
    enable = mkEnableOption "nix import gen" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    qnix.applications.shells.packages = {
      nix-gen-imports = {
        runtimeInputs = [ pkgs.bash ];
        text = ''
          #!/bin/bash
          if [ "$#" -ne 1 ]; then
            echo 'Please use like: nix-gen-imports <module-name>'
            exit
          fi

          if [[ -e "default.nix" ]]; then
            echo "default.nix already exists! Aborting."
          else
            echo "Adding default.nix"
            
            cat > default.nix <<EOF
          {
            ...
          }:

          {
            imports = [
              ./$1
            ];
          }
          EOF
            chmod 644 ./default.nix
            echo "Added default.nix"
          fi
        '';
      };

    };

  };
}
