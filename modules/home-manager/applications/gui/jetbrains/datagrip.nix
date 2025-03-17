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
  config = mkIf config.qnix.applications.gui.jetbrains.datagrip.enable {
    home.packages = with pkgs; [
      jetbrains.datagrip
    ];
  };
}
