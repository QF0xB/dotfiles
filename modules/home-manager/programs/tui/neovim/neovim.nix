{
  config,
  options,
  pkgs,
  lib,
  inputs,
  ...
}:

let 
  cfg = config.qnix.home.applications.tui.neovim;
in
{
  imports = [ inputs.nvf.homeManagerModules.default ];

  options.qnix.home.applications.tui.neovim = with lib; {
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
            lsp = {
              enable = true;
            };

            languages = {
              nix.enable = true;
              python.enable = true; 
            };
          };
        };

      };
    };
  };
}
