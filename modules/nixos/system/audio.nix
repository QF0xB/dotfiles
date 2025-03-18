{
  lib,
  config,
  pkgs,
  host,
  ...
}:

let
  cfg = config.qnix.system.audio;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.qnix.system.audio = {
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
        package = pkgs.master.pipewire;
      };

      pulseaudio.enable = false;
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      pulseaudio
      pamixer
      playerctl
    ];

    systemd = mkIf (host == "QPC") {
      user.services.routeAudio = {
        description = "Route audio from GoXLR to SMSL";
        wantedBy = [ "multi-user.target" ];
        after = [ "pipewire.service" ];
        serviceConfig.Type = "simple";
        script = ''
          ${pkgs.pipewire}/bin/pw-loopback --capture=alsa_input.usb-TC-Helicon_GoXLRMini-00.HiFi__Line4__source --playback=alsa_output.usb-SMSL_SMSL_USB_AUDIO-00.analog-stereo
        '';
      };
    };
  };
}
