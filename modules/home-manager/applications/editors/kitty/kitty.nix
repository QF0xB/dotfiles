{
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.applications.editors.kitty;
in
{
  options.qnix.applications.editors.kitty = with lib; {
    enable = mkEnableOption "kitty" // {
      default = !config.qnix.headless;
    };
  };

  config = {
    programs = {
      kitty = {
        inherit (cfg) enable;

        settings = {
          enable_audio_bell = false;
          update_check_interval = 0;
          confirm_os_window_close = 0;
        };
      };
    };
  };
}
