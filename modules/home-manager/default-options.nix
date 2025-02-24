{
  lib,
  ...
}:

{
  options.qnix = with lib; {
    headless = mkOption {
      description = "Headless client. No GUI.";
      default = false;
      type = types.bool;
    };
  };
}
