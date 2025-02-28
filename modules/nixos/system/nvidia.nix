{
  lib,
  config,
  pkgs,
  ...
}: 

let
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
      nvidia ={
        modesetting.enable = true;
        powerManagement.enable = true;
        open = false;
        nvidiaSettings = false;
      };

      graphics.extraPackages = with pkgs; [
        vaapiVdpau
      ];
    };
  };
}
