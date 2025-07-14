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
  config = mkIf config.qnix.applications.editors.jetbrains.pycharm.enable {
    home.packages = with pkgs; [
      jetbrains.pycharm-professional
    ];
  };
}
