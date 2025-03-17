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
  config = mkIf config.qnix.applications.gui.jetbrains.rust-rover.enable {
    home.packages = with pkgs; [
      jetbrains.rust-rover
    ];
  };
}
