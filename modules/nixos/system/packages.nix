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
  };

  config = with lib; {
    environment.systemPackages = concatLists [ 
      (lists.optionals cfg.git.install [ pkgs.git ])
      (lists.optionals cfg.tree.install [ pkgs.tree ])
    ];
  };
}
