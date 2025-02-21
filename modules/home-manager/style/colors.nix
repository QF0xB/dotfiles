{
  options,
  lib,
  ...
}:

{
  options.qnix.home.style.colors = with lib; {
    scheme = mkOption {
      default = "solarized";
      type = types.str;
      description = "Used Colorscheme";
    };
  };

  imports = [ ./solarized.nix ];
}
