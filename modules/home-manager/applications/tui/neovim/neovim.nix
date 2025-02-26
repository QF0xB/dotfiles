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
    enable = mkEnableOption "neovim";
    default = mkEnableOption "set neovim to default editor";
  };

  config = {
    programs = {
      nvf = {

        enable = cfg.enable;
        defaultEditor = cfg.default;
        settings = {
          vim = {
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
