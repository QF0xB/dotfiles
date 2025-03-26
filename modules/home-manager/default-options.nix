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

    work = mkOption {
      description = "Use for work?";
      default = false;
      type = types.bool;
    };

    design = mkOption {
      description = "Use for design work?";
      default = false;
      type = types.bool;
    };

    development = mkOption {
      description = "Use for development work?";
      default = true;
      type = types.bool;
    };

    externally-accessible = mkOption {
      description = "Open to outside world?";
      default = false;
      type = types.bool;
    };
  };
}
