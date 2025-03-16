{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.system.audio;
in
{
  options.qnix.system.audio = with lib; {
    enable = mkEnableOption "Audiosetup" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      pulseaudio.enable = false;
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      pulseaudio
      pamixer
      playerctl
    ];
  };
}
