{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;

  # myAlternateJdk = pkgs.jdk;

  # clionOverridden = pkgs.jetbrains.clion.override {
  # jdk = myAlternateJdk;
  # };
in
{
  config = mkIf config.qnix.applications.editors.jetbrains.clion.enable {
    home.packages = [
      pkgs.jetbrains.clion
    ];
  };
}
