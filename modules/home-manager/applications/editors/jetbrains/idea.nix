{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;

  myAlternateIdeaJdk = pkgs.jdk;

  ideaOverridden = pkgs.jetbrains.idea-ultimate.override {
    jdk = myAlternateIdeaJdk;
  };

in
{
  config = mkIf config.qnix.applications.editors.jetbrains.idea.enable {
    home.packages = [
      (pkgs.jetbrains.plugins.addPlugins ideaOverridden [
        pkgs.jetbrains.plugins.github-copilot-fixed
      ])
    ];
  };
}
