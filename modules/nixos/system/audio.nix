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
        package = pkgs.master.pipewire; # .overrideAttrs (_: rec {
        # version = "1.4.1";
        # src = pkgs.fetchFromGitLab {
        # domain = "gitlab.freedesktop.org";
        # owner = "pipewire";
        # repo = "pipewire";
        # rev = version;
        # sha256 = "sha256-TnGn6EVjjpEybslLEvBb66uqOiLg5ngpNV9LYO6TfvA=";
        # };
        # });
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
