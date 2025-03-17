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
  config = mkIf config.qnix.applications.gui.jetbrains.pycharm.enable {
    home.packages = with pkgs; [
      master.jetbrains.pycharm-professional
    ];
  };
}
