{
  config,
  lib,
  ...
}:

let
  cfg = config.hm.qnix.applications.editors.neovim;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.default {
    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
