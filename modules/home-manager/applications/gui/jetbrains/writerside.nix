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
  config = mkIf config.qnix.applications.gui.jetbrains.writerside.enable {
    home.packages = with pkgs; [
      jetbrains.writerside
    ];
  };
}
