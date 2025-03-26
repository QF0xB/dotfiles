{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.hardware.nvidia;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.hardware.nvidia = {
    enable = mkEnableOption "nvidia" // {
      default = false;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      cursor = {
        # no_hardware_cursors = true;
        use_cpu_buffer = 1;
      };

      render = {
        explicit_sync = 1;
        # allow_early_buffer_release = true;
      };
    };
  };
}
