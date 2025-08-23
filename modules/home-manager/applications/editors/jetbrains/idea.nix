{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;

  # myAlternateIdeaJdk = pkgs.jdk;

  # ideaOverridden = pkgs.jetbrains.idea-ultimate.override {
  # jdk = myAlternateIdeaJdk;
  # };

in
{
  config = mkIf config.qnix.applications.editors.jetbrains.idea.enable {
    home.packages = with pkgs; [
      (jetbrains.plugins.addPlugins jetbrains.idea-ultimate [
        "github-copilot"
      ])
      nodejs
      # (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate [
      # pkgs.jetbrains.plugins.github-copilot-fixed
      # ])
    ];
  };
}
