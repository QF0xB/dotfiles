{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;

  myAlternateJdk = pkgs.jdk;

  pycharmOverridden = pkgs.jetbrains.pycharm-professional.override {
    jdk = myAlternateJdk;
  };
in
{
  config = mkIf config.qnix.applications.editors.jetbrains.pycharm.enable {
    home.packages = [
      pycharmOverridden
    ];
  };
}
