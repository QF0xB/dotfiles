{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.applications.audio.pipewire;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.audio.pipewire = {
    enable = mkEnableOption "pipewire audio setup" // {
      default = true;
    };

    debug = mkEnableOption "debug mode of pipewire";
  };

  config = mkIf cfg.enable {
    qnix.persist.home = {
      directories = [
        ".local/state/wireplumber"
      ];
    };
  };
}
