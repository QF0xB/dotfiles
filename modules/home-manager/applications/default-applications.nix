{
  lib,
  pkgs,
  ...
}:

{
  options.qnix.applications.default = with lib; {
    terminal = mkOption {
      type = types.package;
      description = "The default terminal emulator.";
      default = pkgs.kitty;
    };
    file-manager = mkOption {
      type = types.package;
      description = "The default file-manager emulator.";
      default = pkgs.nemo;
    };
    browser = mkOption {
      type = types.package;
      description = "The default browser.";
      default = pkgs.brave;
    };
  };
}
