{
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
}
