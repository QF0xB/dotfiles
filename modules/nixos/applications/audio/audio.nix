
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pavucontrol
      pulseaudio
      pamixer
      playerctl
    ];

