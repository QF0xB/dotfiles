{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.system.packages;
in
{
  options.qnix.system.packages = with lib; {
    git.install = mkEnableOption "git install" // {
      default = true;
    };
    tree.install = mkEnableOption "tree install" // {
      default = true;
    };
    yubico.install = mkEnableOption "yubico software" // {
      default = true;
    };
    helix.install = mkEnableOption "helix" // {
      default = false;
    };
    kitty.install = mkEnableOption "kitty" // {
      default = true;
    };
    nemo.install = mkEnableOption "nemo" // {
      default = true;
    };
  };

  config.environment.variables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  # MOVED TO ./environment
  #  config = with lib; {
  #    environment.systemPackages = concatLists [
  #      (lists.optionals cfg.git.install [ pkgs.git ])
  #      (lists.optionals cfg.tree.install [ pkgs.tree ])
  #    ];
  #  };
}
