{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.gui.vscode;
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.gui.vscode = {
    enable = mkEnableOption "vscode" // {
      default = !config.qnix.headless;
    };
  };

  config = {
    programs.vscode = {
      enable = cfg.enable;
      package = pkgs.vscodium;
    };

    qnix.persist.home.directories = [
      ".config/VSCodium"
      ".vscode-oss"
    ];
  };
}
