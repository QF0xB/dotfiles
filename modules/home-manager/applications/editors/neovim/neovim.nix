{
  config,
  lib,
  pkgs,
  dots,
  ...
}:

let
  cfg = config.qnix.applications.editors.neovim;
in
{
  options.qnix.applications.editors.neovim = with lib; {
    enable = mkEnableOption "neovim" // {
      default = true;
    };
    default = mkEnableOption "set neovim to default editor" // {
      default = true;
    };
  };

  config = {
    qnix.persist.home = {
      directories = [
        ".local/share/nvf/site/spell"
      ];
    };

    programs = {
      nvf = {
        inherit (cfg) enable;
        defaultEditor = cfg.default;
        settings = {
          vim = {

            spellcheck = {
              enable = true;
              programmingWordlist.enable = true; # :DirtytalkUpdate
            };

            options = {
              expandtab = true;
              shiftwidth = 2;
              tabstop = 2;
            };

            lsp = {
              enable = true;
              formatOnSave = true;
              lightbulb.enable = true;
              lspkind.enable = true;
            };

            treesitter = {
              enable = true;
              highlight.enable = true;
              indent.enable = true;
              autotagHtml = true;
            };

            languages = {
              enableFormat = true;
              enableTreesitter = true;
              enableExtraDiagnostics = true;

              nix = {
                enable = true;

                format = {
                  enable = true;
                  package = pkgs.nixfmt-rfc-style;
                  type = "nixfmt";
                };

                lsp = {
                  package = pkgs.nixd;
                  server = "nixd";
                  options = lib.mkIf (dots != null) {
                    nixos = {
                      expr = ''(builtins.getFlake "${dots}").nixosConfigurations."QFrame13".options'';
                    };
                    home-manager = {
                      expr = ''(builtins.getFlake "${dots}").homeConfigurations."QFrame13".options'';
                    };
                  };
                };
              };
              python.enable = true;
            };

            autopairs.nvim-autopairs.enable = true;

            autocomplete.nvim-cmp = {
              enable = true;

              sources = {
                path = "[Path]";
              };
            };

            luaConfigRC = {

              "00-disable-deprecations" = ''
                vim.deprecate = function() end
              '';
            };
          };
        };

      };
    };
  };
}
