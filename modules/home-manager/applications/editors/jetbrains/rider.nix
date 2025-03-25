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
  config = mkIf config.qnix.applications.editors.jetbrains.rider.enable {
    home.packages = with pkgs; [
      jetbrains.rider
    ];
  };
}
