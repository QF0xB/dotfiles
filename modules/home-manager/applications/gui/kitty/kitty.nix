{
  lib,
  config,
  isNixOS,
  ...
}:

let
  cfg = config.qnix.applications.general.kitty;
in
{
  options.qnix.applications.general.kitty = with lib; {
    enable = mkEnableOption "kitty" // {
      default = isNixOS && !config.qnix.headless;
    };
  };

  config = {
    programs = {
      kitty = {
        enable = cfg.enable;

        settings = {
          enable_audio_bell = false;
          update_check_interval = 0;
          confirm_os_window_close = 0;
        };
      };
    };
  };
}
