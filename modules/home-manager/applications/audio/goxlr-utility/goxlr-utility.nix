{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.audio.goxlr-utility = {
    enable = mkEnableOption "goxlr-utility";
  };

  config = {
    qnix.persist.home = {
      directories = [
        ".config/goxlr-utility"
        ".local/share/goxlr-utility"
      ];
    };
  };
}
