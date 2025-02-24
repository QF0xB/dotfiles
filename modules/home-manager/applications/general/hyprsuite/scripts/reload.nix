{
  ...
}:

{
  config = {
    home.file.".config/hypr/scripts/reload.sh" = {
      text = ''
        #!/bin/sh
        killall waybar
        waybar &
        hyprctl reload 
        killall hyprpaper 
        hyprpaper
      '';
      executable = true;
    };
  };
}
