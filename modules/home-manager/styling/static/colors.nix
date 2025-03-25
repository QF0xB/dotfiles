{
  lib,
  ...
}:

{
  options.qnix.home.styling.static.colors = with lib; {
    scheme = mkOption {
      default = "solarized-dark";
      type = types.str;
      description = "Used Colorscheme";
    };
  };

  imports = [
    ./solarized-dark.nix
  ];
}
