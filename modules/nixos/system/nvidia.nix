{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) optionalAttrs;
  cfg = config.qnix.system.nvidia;
in
{
  options.qnix.system.nvidia = with lib; {
    enable = mkEnableOption "Nvidia GPU";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    boot = {
      #nvidia-uvm needed for CUDA
      kernelModules = [ "nvidia-uvm" ];
    };

    hardware = {
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        open = false;
        nvidiaSettings = true;

      };

      graphics.extraPackages = with pkgs; [
        vaapiVdpau
      ];
    };

    environment.variables = optionalAttrs config.programs.hyprland.enable {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    hm.wayland.windowManager.hyprland.settings = {
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
