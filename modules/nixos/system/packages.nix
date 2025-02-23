{
  options,
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.system.packages;
in
{
  options.qnix.system.packages = with lib; {
    git.install = mkEnableOption "git install";
    tree.install = mkEnableOption "tree install";
    yubico.install = mkEnableOption "yubikey";
    helix.install = mkEnableOption "helix";
    kitty.install = mkEnableOption "kitty";
  };

  # MOVED TO ./environment
  #  config = with lib; {
  #    environment.systemPackages = concatLists [
  #      (lists.optionals cfg.git.install [ pkgs.git ])
  #      (lists.optionals cfg.tree.install [ pkgs.tree ])
  #    ];
  #  };
}
