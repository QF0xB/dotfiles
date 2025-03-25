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
  config = mkIf config.qnix.applications.editors.jetbrains.webstorm.enable {
    home.packages = with pkgs; [
      jetbrains.webstorm
    ];
  };
}
