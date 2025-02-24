{
  lib,
  ...
}:

{
  # This activation script runs after your Home Manager configuration activates.
  # It creates ~/.config/hypr/monitor.conf with default content if the file doesn't exist.
  home.activation.createHyprMonitorConf = lib.mkAfter ''
        if [ ! -f "$HOME/.config/hypr/monitor.conf" ]; then
          mkdir -p "$HOME/.config/hypr"
          cat > "$HOME/.config/hypr/monitor.conf" << 'EOF'
    # Default Hyprland monitor configuration
    # You can customize this file after it's created.
    monitor = , preferred, auto, 1
    EOF
        fi
  '';
  qnix.persist.home.files = [
    ".config/hypr/monitor.conf"
  ];
}
