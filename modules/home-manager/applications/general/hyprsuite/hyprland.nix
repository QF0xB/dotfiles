{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.home.applications.general.hyprsuite;
in
{
  imports = [
    ./scripts/reload.nix
    ./monitors.nix
  ];

  options.qnix.home.applications.general.hyprsuite.hyprland = with lib; {
    enable = mkEnableOption "hyprland home module";
  };

  config = {
    wayland.windowManager = {
      hyprland = {
        enable = cfg.hyprland.enable;
        package = null;
        portalPackage = null;
        systemd.enable = false;

        settings = {
          # Monitor
          monitor = ", preferred, auto, 1"; # Default Monitor
          source = "./monitor.conf";

          exec-once = [
            "hyprctl switchxkblayout all 1"
          ];
          # General window settings: gaps, border size, layout, and colors.
          general = {
            gaps_in = "5"; # Inner gaps between windows
            gaps_out = "20"; # Outer gaps (to monitor edge)
            border_size = "2"; # Border thickness
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg"; # Active window border gradient
            "col.inactive_border" = "rgba(595959aa)"; # Inactive window border color
            layout = "dwindle"; # Tiling layout (dwindle)
            resize_on_border = "true"; # Allow resizing by dragging borders
            allow_tearing = "false"; # Tearing disabled (see wiki for details)
          };

          # Decoration settings: rounded corners and blur effect.
          decoration = {
            rounding = "10"; # Rounded corners (in pixels)
            blur = {
              enabled = "true"; # Enable blur effect
              size = "10"; # Blur distance
              passes = "1"; # Number of blur passes
              new_optimizations = "on"; # Use optimized blur method
            };
            # (Optional: add drop shadow settings if desired)
          };

          # Animation settings: define custom animations using a bezier curve.
          animations = {
            enabled = "yes"; # Enable animations
          };

          # Input settings: keyboard layout, touchpad behavior, etc.
          input = {
            kb_layout = "us,de"; # German keyboard layout
            kb_variant = ",koy"; # Variant: koy
            kb_model = "";
            kb_rules = "";
            follow_mouse = "1"; # Enable focus follow on mouse movement
            scroll_method = "2fg"; # Two-finger scrolling
            force_no_accel = "true"; # Use raw input (disable acceleration)
            sensitivity = "0"; # No sensitivity modification
            touchpad = {
              natural_scroll = "false"; # Normal (non-inverted) scroll direction
              clickfinger_behavior = "true"; # Enable clickfinger mapping
            };
          };

          # Miscellaneous settings: wallpaper, logos, and window swallowing.
          misc = {
            force_default_wallpaper = "0"; # Use default wallpaper (-1=random, 0=off)
            disable_hyprland_logo = "true"; # Disable Hyprland logo animation
            disable_splash_rendering = "true"; # Disable splash screen
            vfr = "true";
            vrr = "1";
            enable_swallow = "true"; # Enable window swallowing
            swallow_regex = "'^(kitty)$'"; # Swallow windows matching this regex
            focus_on_activate = "true"; # Focus windows when they request activation
          };
          # Device-specific configurations (list of per-device overrides)
          device = [
            {
              name = "epic-mouse-v1";
              sensitivity = "-0.5"; # Adjust sensitivity for this device
            }
            {
              name = "yubico-yubikey-otp+fido+ccid";
              kb_layout = "us"; # Use US layout for this device
              kb_variant = "";
              kb_options = "";
            }
            {
              name = "ydotoold-virtual-device";
              kb_layout = "us";
              kb_variant = "";
              kb_options = "";
            }
          ];

          # Debug settings: enable logs for troubleshooting.
          debug = {
            disable_logs = "false";
          };

          #
          # KEYBINDS
          #

          # Set main mod to windows key.
          "$mod" = "super";

          bindl = [
            ",switch:Lid Switch,exec,swaylock" # Lock when lid closed.
          ];
          bindm = [
            # Move window with Mouse + MOD
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
          bind =
            [
              # Hyprland behavior
              "$mod SHIFT, code:26, exec, ~/.config/hypr/scripts/reload.sh #e" # Added  ./scripts/reload.nix
              "$mod SHIFT, code:53, exec, uwsm stop #x" # Stop hyprland
              "$mod, code:42, exec, hyprctl switchxkblayout all next #g" # Cycle keyboard layout

              # Scroll through existing workspaces with mainMod + scroll
              "$mod, mouse_down, workspace, e+1"
              "$mod, mouse_up, workspace, e-1"

              #
              # Windows
              #

              # Behavior
              "$mod, code:48, fullscreen #;" # Fullscreen window
              "$mod, code:38, killactive #A" # Kill focused window
              "$mod SHIFT, code:48, togglefloating #;" # Float focused window

              # Layout
              # bind = $mainMod, d, pseudo, # dwindle
              "$mod, code:61, togglesplit, #?" # dwindle
              "$mod, Tab, cyclenext" # Focus next window
              "ALT, Tab, swapnext" # Switch focused with next window
              "CTRL, Tab, workspace, e+" # go to next workspace

              # Move focus with mainMod + arrow keys
              "$mod, left, movefocus, l"
              "$mod, right, movefocus, r"
              "$mod, up, movefocus, u"
              "$mod, down, movefocus, d"

              #
              # Programs
              #

              #Shell
              "$mod, return, exec, kitty" # Start kitty normally
              "$mod CTRL, return, exec, kitty --class floating" # Start kitty floating

              #Browser
              "$mod, code:47, exec, brave #;" # Start brave normally
              "$mod CTRL, code:47, exec, brave --private-window #;" # Start brave in private mode

              # WOFI (ROFI)
              "CTRL,SUPER_L, exec, wofi" # Program starter

              # Recording
              "$mod, code:29, exec, obs #z" # Start obs

              # General use
              "$mod, code:40, exec, thunar #d" # Filemanager
              "$mod, code:57, exec, bitwarden-desktop #m" # Passwordmanager
              "$mod, code:26, exec, obsidian #e" # Notes

              # Screenshot
              "SHIFT, Print, exec, grim -g '$slurp' - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify -i ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png 'Screenshot of the region taken' -t 1000" # screenshot of a region
              ", Print, exec, grim - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify  -i ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png 'Screenshot of whole screen taken' -t 1000" # screenshot of the whole screen

              # audio/sound control
              ", xf86audioraisevolume, exec, pamixer -i 5 && dunstify -h int:value:'$(pamixer --get-volume)' -i ~/.config/dunst/assets/volume.svg -t 500 -r 2593 'Volume: $(pamixer --get-volume) %'"
              ", xf86audiolowervolume, exec, pamixer -d 5 && dunstify -h int:value:'$(pamixer --get-volume)' -i ~/.config/dunst/assets/volume.svg -t 500 -r 2593 'Volume: $(pamixer --get-volume) %'"
              ", xf86AudioMute, exec, pamixer -t && dunstify -i ~/.config/dunst/assets/$(pamixer --get-mute | grep -q 'true' && echo 'volume-mute.svg' || echo 'volume.svg') -t 500 -r 2593 'Toggle Mute'"
              ", XF86AudioPlay, exec, playerctl play-pause"
              ", XF86AudioNext, exec, playerctl next"
              ", XF86AudioPrev, exec, playerctl previous"
              ", XF86audiostop, exec, playerctl stop"
            ]
            ++ (
              let
                # Define workspaces as a list of records.
                workspaces = [
                  {
                    num = "1";
                    code = "58";
                    comment = "m";
                  }
                  {
                    num = "2";
                    code = "59";
                    comment = ",";
                  }
                  {
                    num = "3";
                    code = "60";
                    comment = ".";
                  }
                  {
                    num = "4";
                    code = "44";
                    comment = "j";
                  }
                  {
                    num = "5";
                    code = "45";
                    comment = "k";
                  }
                  {
                    num = "6";
                    code = "46";
                    comment = "l";
                  }
                  {
                    num = "7";
                    code = "30";
                    comment = "u";
                  }
                  {
                    num = "8";
                    code = "31";
                    comment = "i";
                  }
                  {
                    num = "9";
                    code = "32";
                    comment = "o";
                  }
                  {
                    num = "10";
                    code = "65";
                    comment = "space";
                  }
                ];

                # When displaying a workspace key we want "10" to be shown as "0".
                conv = ws: if ws == "10" then "0" else ws;

                # generateBindings takes one workspace record and returns a list of six binding lines.
                generateBindings =
                  wRec:
                  let
                    n = wRec.num;
                    c = wRec.code;
                    comm = wRec.comment;
                    cn = conv n;
                  in
                  [
                    ("$mod, " + cn + ", workspace, " + cn)
                    ("$mod, code:" + builtins.toString c + ", workspace, " + n + " #" + comm)
                    ("$mod+SHIFT+CTRL, " + cn + ", movetoworkspace, " + cn)
                    ("$mod+SHIFT+CTRL, code:" + builtins.toString c + ", movetoworkspace, " + n + " #" + comm)
                    ("$mod CTRL, " + cn + ", movetoworkspacesilent, " + cn)
                    ("$mod CTRL, code:" + builtins.toString c + ", movetoworkspacesilent, " + n + " #" + comm)
                  ];

                # bindingLines is the concatenation of all binding lists.
                bindingLines = builtins.concatLists (map generateBindings workspaces);
              in
              bindingLines
            );
        };
      };
    };
  };
}
