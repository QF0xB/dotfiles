{
  lib,
  ...
}:

{
  options.qnix.home.styling.static.colors.solarized-dark = with lib; {
    base03 = mkOption {
      default = "#002b36";
      type = types.str;
      description = "background";
    };
    base02 = mkOption {
      default = "#073642";
      type = types.str;
      description = "background highlights";
    };
    base01 = mkOption {
      default = "#586e75";
      type = types.str;
      description = "comments / secondary content";
    };
    base00 = mkOption {
      default = "#657b83";
      type = types.str;
      description = "Rarely used";
    };
    base0 = mkOption {
      default = "#839496";
      type = types.str;
      description = "text / primary content";
    };
    base1 = mkOption {
      default = "#93a1a1";
      type = types.str;
      description = "emphasized";
    };
    yellow = mkOption {
      default = "#b58900";
      type = types.str;
      description = "solarized yellow";
    };
    orange = mkOption {
      default = "#cb4b16";
      type = types.str;
      description = "solarized orange";
    };
    red = mkOption {
      default = "#dc322f";
      type = types.str;
      description = "solarized red";
    };
    magenta = mkOption {
      default = "#d33682";
      type = types.str;
      description = "solarized magenta";
    };
    violet = mkOption {
      default = "#6c71c4";
      type = types.str;
      description = "solarized violet";
    };
    blue = mkOption {
      default = "#268bd2";
      type = types.str;
      description = "solarized blue";
    };
    cyan = mkOption {
      default = "#2aa198";
      type = types.str;
      description = "solarized cyan";
    };
    green = mkOption {
      default = "#859900";
      type = types.str;
      description = "solarized green";
    };
  };
}
