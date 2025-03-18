{
  lib,
  ...
}:

let
  inherit (lib) mkOption types;
in
{
  options.qnix = {
    headless = mkOption {
      description = "Headless client. No GUI.";
      default = false;
      type = types.bool;
    };

    wayland = mkOption {
      description = "Wayland activated?";
      default = false;
      type = types.bool;
    };
  };
}
