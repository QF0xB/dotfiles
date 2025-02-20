{
  config,
  options,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./fish.nix
  ];

  options.qnix.terminal = with lib; {
    package = mkOption {
      type = types.package;
      default = pkgs.kitty;
      description = "Terminal package to use.";
    };

    size = mkOption {
      type = types.int;
      default = 14;
      description = "Font size to use in terminal";
    };

    
  };

  config = {
    home.packages = with pkgs; [
      dysk #better disk info
      ets #timestamps before each line
      fd #better find
      fx #json viewer
      jq #another json viewer
      
    ];
  };
}
