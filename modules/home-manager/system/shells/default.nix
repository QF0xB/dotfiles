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
    ./aliases.nix
    ./lsd.nix
    ./starship.nix
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
      (callPackage ../../../../packages/rofi/package.nix { })
      dysk # better disk info
      ets # timestamps before each line
      fd # better find
      fx # json viewer
      jq # another json viewer

    ];

    programs.nix-index.enable = true;

    qnix.persist = {
      home = {
        cache.directories = [ ".cache/nix-index" ];
      };
    };

    qnix.home.system.shell = with lib; {
      fish.enable = mkDefault true;
      lsd.enable = mkDefault true;
      starship.enable = mkDefault true;
    };
  };
}
