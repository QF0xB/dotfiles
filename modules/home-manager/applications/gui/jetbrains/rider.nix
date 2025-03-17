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
  config = mkIf config.qnix.applications.gui.jetbrains.rider.enable {
    home.packages = with pkgs; [
      jetbrains.rider
    ];
  };
}
