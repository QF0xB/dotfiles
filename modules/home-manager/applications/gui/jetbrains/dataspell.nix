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
  config = mkIf config.qnix.applications.gui.jetbrains.dataspell.enable {
    home.packages = with pkgs; [
      jetbrains.dataspell
    ];
  };
}
