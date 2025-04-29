{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.editors.vscode;
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.editors.vscode = {
    enable = mkEnableOption "vscode" // {
      default = !config.qnix.headless;
    };
  };

  config = {
    programs.vscode = {
      inherit (cfg) enable;

      package = pkgs.vscodium;

      profiles.default.extensions = with pkgs.vscode-extensions; [
      ];
    };

    qnix.persist.home.directories = [
      ".config/VSCodium"
      ".vscode-oss"
    ];
  };
}
