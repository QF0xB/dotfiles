{
  config,
  lib,
  inputs,
  dots,
  ...
}:

let
  cfg = config.qnix.applications.tui.neovim;
in
{
  imports = [ inputs.nvf.homeManagerModules.default ];

  options.qnix.applications.tui.neovim = with lib; {
    enable = mkEnableOption "neovim" // {
      default = true;
    };
    default = mkEnableOption "set neovim to default editor" // {
      default = true;
    };
  };

  config = {
    programs = {
      nvf = {

        enable = cfg.enable;
        defaultEditor = cfg.default;
        settings = {
          vim = {
            theme = {
              enable = true;
              name = "base16";
              base16-colors = {
                base00 = "#002b36";
                base01 = "#073642";
                base02 = "#586e75";
                base03 = "#657b83";
                base04 = "#839496";
                base05 = "#93a1a1";
                base06 = "#eee8d5";
                base07 = "#fdf6e3";
                base08 = "#dc322f";
                base09 = "#cb4b16";
                base0A = "#b58900";
                base0B = "#859900";
                base0C = "#2aa198";
                base0D = "#268bd2";
                base0E = "#6c71c4";
                base0F = "#d33682";
              };
            };
            options = {
              expandtab = true;
              shiftwidth = 2;
              tabstop = 2;
            };
            lsp = {
              enable = true;
              formatOnSave = true;
              # lightbulb.enable = true;
              lspkind.enable = true;
            };

            languages = {
              enableLSP = true;
              enableFormat = true;
              enableTreesitter = true;
              nix = {
                enable = true;
                format.type = "nixfmt";
                lsp = {
                  server = "nixd";
                  options = lib.mkIf (dots != null) {
                    nixos = {
                      expr = "(builtins.getFlake \"${dots}\").nixosConfigurations.desktop.options";
                    };
                    home-manager = {
                      expr = "(builtins.getFlake \"${dots}\").homeConfigurations.desktop.options";
                    };
                  };
                };
              };
              python.enable = true;
            };

            autopairs.nvim-autopairs.enable = true;
            autocomplete.nvim-cmp.enable = true;
          };
        };

      };
    };
  };
}
