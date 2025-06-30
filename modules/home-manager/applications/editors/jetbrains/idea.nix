{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
in
{
  config = mkIf config.qnix.applications.editors.jetbrains.idea.enable {
    home.packages = [
      (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate [
        pkgs.jetbrains.plugins.github-copilot-fixed
      ])
    ];
  };
}
