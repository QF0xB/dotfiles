{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.qnix.nix.code-gen.template-gen;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.nix.code-gen.template-gen = {
    enable = mkEnableOption "nix import gen" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    qnix.applications.shells.packages = {
      nix-gen-enable-options = {
        runtimeInputs = [ pkgs.bash ];
        text = ''
          #!/bin/bash
          if [ "$#" -ne 2 ]; then
            echo 'Please use like: nix-gen-options <module-name> <module-path>'
            exit
          fi

          if [[ -e "$1"-options.nix ]]; then
            echo "$1-options.nix already exists! Aborting."
          else
            echo "Adding $1-options.nix"
            
            cat > "$1"-options.nix <<EOF
          {
            lib,
            ...
          }:

          let
            inherit (lib) mkEnableOption;
          in
          {
            options.qnix.$2 = {
              enable  = mkEnableOption "$1" // {
                default = false;
              };
            };
          }
          EOF
            chmod 644 ./"$1"-options.nix
            echo "Added $1-options.nix"
          fi
        '';
      };

      nix-gen-options = {
        runtimeInputs = [ pkgs.bash ];
        text = ''
          #!/bin/bash
          if [ "$#" -ne 2 ]; then
            echo 'Please use like: nix-gen-options <module-name> <option-path>'
            exit
          fi

          if [[ -e "$1"-options.nix ]]; then
            echo "$1-options.nix already exists! Aborting."
          else
            echo "Adding $1-options.nix"
            
            cat > "$1"-options.nix <<EOF
          {
            lib,
            ...
          }:

          let
            inherit (lib) ;
          in
          {
            options.qnix.$2 = {

            };
          }
          EOF
            chmod 644 "$1"-options.nix
            echo "Added $1-options.nix"
          fi
        '';
      };

      nix-gen-config = {
        runtimeInputs = [ pkgs.bash ];
        text = ''
          #!/bin/bash
          if [ "$#" -ne 2 ]; then
            echo 'Please use like: nix-gen-options <module-name> <config-path>'
            exit
          fi

          if [[ -e "$1".nix ]]; then
            echo "$1.nix already exists! Aborting."
          else
            echo "Adding $1.nix"
            
            cat > "$1".nix <<EOF
          {
            config,
            lib,
            ...
          }:

          let
            cfg = config.qnix.$2;
            inherit (lib) mkIf;
          in
          {
            config = mkIf cfg.enable {

            };
          }
          EOF
            chmod 644 "$1".nix
            echo "Added $1.nix"
          fi
        '';
      };

      nix-gen-config-options = {
        runtimeInputs = [ pkgs.bash ];
        text = ''
          #!/bin/bash
          if [ "$#" -ne 2 ]; then
            echo 'Please use like: nix-gen-options <module-name> <config-path>'
            exit
          fi

          if [[ -e "$1".nix ]]; then
            echo "$1.nix already exists! Aborting."
          else
            echo "Adding $1.nix"
            
            cat > "$1".nix <<EOF
          {
            config,
            lib,
            ...
          }:

          let
            cfg = config.qnix.$2;
            inherit (lib) mkEnableOption mkIf;
          in
          {
            options.qnix.$2 = {
              enable = mkEnableOption "$1" // {
                default = false;
              };
            };
            
            config = mkIf cfg.enable {

            };
          }
          EOF
            chmod 644 "$1".nix
            echo "Added $1.nix"
          fi
        '';
      };

    };
  };
}
