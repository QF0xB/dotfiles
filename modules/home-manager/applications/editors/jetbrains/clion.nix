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
  config = mkIf config.qnix.applications.editors.jetbrains.clion.enable {
    home.packages = with pkgs; [
      jetbrains.clion
    ];
  };
}
