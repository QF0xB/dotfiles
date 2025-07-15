{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.hm.qnix.applications.audio;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.pipewire.enable {
    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        package = pkgs.pipewire;
      };

      pulseaudio.enable = false;
    };

    environment.variables = mkIf cfg.pipewire.debug {
      PIPEWIRE_DEBUG = 5;
    };

    systemd = mkIf cfg.goxlr-utility.enable {
      user.services.routeAudio = {
        enable = true;

        description = "Route audio from GoXLR to SMSL";
        wantedBy = [ "default.target" ];
        after = [ "pipewire.service" ];
        serviceConfig.Type = "simple";
        script = ''
          ${pkgs.pipewire}/bin/pw-loopback --capture=alsa_input.usb-TC-Helicon_GoXLRMini-00.HiFi__Line4__source --playback=alsa_output.usb-SMSL_SMSL_USB_AUDIO-00.analog-stereo
        '';
      };
    };

  };
}
