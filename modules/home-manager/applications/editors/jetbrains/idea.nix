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
  config = mkIf config.qnix.applications.editors.jetbrains.idea.enable {
    home.packages = with pkgs; [
      jetbrains.idea-ultimate
      nodejs
    ];
  };
}
