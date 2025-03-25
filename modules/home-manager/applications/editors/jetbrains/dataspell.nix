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
  config = mkIf config.qnix.applications.editors.jetbrains.dataspell.enable {
    home.packages = with pkgs; [
      jetbrains.dataspell
    ];
  };
}
