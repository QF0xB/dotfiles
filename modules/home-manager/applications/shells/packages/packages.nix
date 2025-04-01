{
  lib,
  ...
}:

let
  inherit (lib)
    mkOption
    types
    qnix-lib
    ;
in
{
  options.qnix.applications.shells = {
    packages = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          str
          attrs
          package
        ]);
      apply = qnix-lib.mkShellPackages;
      default = { };
      description = ''
        Attrset of shell packages to install and add to pkgs.custom overlay (for compatibility across multiple shells).
        Both string and attr values will be passed as arguments to writeShellApplicationCompletions
      '';
      example = ''
        shell.packages = {
          myPackage1 = "echo 'Hello, World!'";
          myPackage2 = {
            runtimeInputs = [ pkgs.hello ];
            text = "hello --greeting 'Hi'";
          };
        };
      '';
    };
  };

  config = {
    qnix.applications.shells = {
      packages = {
        nr = # sh
          ''
            if [ "$#" -eq 0 ]; then
                echo "no package specified."
                exit 1
            fi

            # assume building packages in local nixpkgs if possible
            src="nixpkgs"
            if [[ $(pwd) =~ /nixpkgs$ ]]; then
                src="."
            # dotfiles, custom package exists, build it
            elif [[ $(pwd) =~ /dotfiles$ ]]; then
                if [[ -d "./packages/$1" ]]; then
                  src="."
                else
                  src="nixpkgs"
                fi
            # flake
            elif [[ -f flake.nix ]]; then
                if nix eval ".#$1" &>/dev/null; then
                  src="."
                fi
            fi

            if [ "$src" = "nixpkgs" ]; then
                # don't bother me about unfree
                NIXPKGS_ALLOW_UNFREE=1 nix run --impure "$src#$1" -- "''${@:2}"
            else
                nix run "$src#$1" -- "''${@:2}"
            fi
          '';
      };
    };
  };
}
