{
  lib,
  ...
}:

let
  inherit (lib) mkOption types;
in
{
  options.qnix.hardware.keyboard = {
    default = mkOption {
      description = "Default Keyboard.";
      type = types.str;
      default = "all";
      example = "all";
    };
  };
}
