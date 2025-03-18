{
  config,
  lib,
  isLaptop,
  ...
}:

{
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";

      modules-left = [
        "custom/side-spacer"
        #   "custom/logo";
        "custom/arrow-l-clock"
        #		"custom/logo";
        "clock"
        "custom/arrow-r-clock"
        "custom/arrow-l-work"
        "hyprland/workspaces"
        "custom/arrow-r-work"
        "custom/arrow-l-tray"
        "custom/yubikey"
        "tray"
        "custom/arrow-r-tray"
      ];

      modules-right =
        with lib;
        [
          "custom/arrow-l-interact"
          "custom/clipboard"
          "custom/sep-interact"
          "hyprland/language"
          "custom/arrow-r-interact"
          "custom/arrow-l-system"
          "network"
          "custom/sep-system"
          "pulseaudio"
          "custom/arrow-r-system"
          "custom/arrow-l-stats"
          "cpu"
          "memory"
          "custom/sep-stats"
        ]
        ++ (lists.optionals isLaptop [
          "battery"
          "custom/sep-stats"
        ])
        ++ [
          "custom/notification"
          "custom/arrow-r-stats"
          "custom/side-spacer"
        ];

      # Modules

      "custom/logo" = {
        format = "  ";
        tooltip = false;
        on-click = "~/.config/rofi/launchers/type-${config.qnix.applications.desktop.rofi.launcher.theme.type}/style-${config.qnix.applications.desktop.rofi.launcher.theme.type}.rasi &";
      };

      "custom/side-spacer" = {
        format = " ";
        tooltip = false;
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = " <span foreground='red'><sup></sup></span>";
          none = " ";
          dnd-notification = " <span foreground='red'><sup></sup></span>";
          dnd-none = " ";
          inhibited-notification = " <span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = " <span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = " ";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };

      backlight = {
        device = "video1";
        format = " ";
        format-alt = "{percent}%";
        tooltip = false;
      };

      "custom/pacman" = {
        format = "{icon}{}";
        return-type = "json";
        format-icons = {
          pending-updates = " ";
          updated = " ";
        };
        exec-if = "which waybar-updates";
        exec = "waybar-updates";
      };

      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };

      battery = {
        interval = 10;
        full-at = 99;
        bat = "BAT1";
        adapter = "ACAD";
        states = {
          warning = 30;
          critical = 15;
        };
        format-time = "{H} ={M =02}";
        format = "{icon} {capacity}%";
        format-plugged = "";
        format-charging = " {capacity}%";
        format-alt = "{icon} {power}W";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
        tooltip = "{time}";
        on-click-right = "swaync-client -t -sw";
      };

      clock = {
        tooltip-format = "<tt>{calendar}</tt>";
        format-alt = " {:%a, %d %b %Y}";
        format = " {:%H:%M}";
      };

      cpu = {
        interval = 5;
        tooltip = false;
        format = " {usage}%";
        format-alt = " {load}";
        states = {
          warning = 70;
          critical = 90;
        };
      };

      memory = {
        interval = 5;
        format = "{used:0.0f}G";
        states = {
          warning = 70;
          critical = 90;
        };
        tooltip = false;
      };

      network = {
        interval = 5;
        format-wifi = "{icon}";
        format-ethernet = "󰈁";
        format-disconnected = "󰈂";
        format-alt = " {ipaddr}/{cidr}";
        format-icons = [
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        tooltip-format-ethernet = "{ifname} = {ipaddr}/{cidr}\ngateway = {gwaddr}\ndown = {bandwidthDownBits}\nup = {bandwidthUpBits}";
        tooltip-format-wifi = "{ifname} = {ipaddr}/{cidr}\ngateway = {gwaddr}\nssid = {essid}\nsignal = {signaldBm} dbm\ndown = {bandwidthDownBits}\nup = {bandwidthUpBits}";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-bluetooth = "{icon} {volume}%";
        format-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
          ];
        };
        scroll-step = 1;
        on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        tooltip = false;
      };

      temperature = {
        critical-threshold = 90;
        interval = 5;
        format = "{icon} {temperatureC}°";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
        tooltip = false;
      };

      "custom/yubikey" = {
        exec = "~/.config/waybar/waybar-yubikey";
        return-type = "json";
      };

      tray =
        let
          iconSize = if isLaptop then 20 else 25;
        in
        {
          icon-size = iconSize;
          spacing = 10;
        };

      "custom/clipboard" = {
        format = "";
        return-type = "json";
        on-click = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
        on-click-right = "cliphist list | rofi --dmenu | cliphist delete && pkill -RTMIN+9 waybar";
        on-click-middle = "rm -f ~/.cache/cliphist/db; pkill -RTMIN+9 waybar";
        tooltip = false;
        signal = 9;
      };

      "hyprland/language" = {
        format-de = "KOY";
        format-en = "EN";
        on-click = "hyprctl switchxkblayout all next && systemctl restart --user waybar.service";
        keyboard-name = "video-bus";
      };

      "custom/arrow-l-clock" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow-r-clock" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow-l-work" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow-r-work" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow-l-tray" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow-r-tray" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow-l-interact" = {
        format = "";
        tooltip = false;
      };

      "custom/sep-interact" = {
        format = "|";
        tooltip = false;
      };

      "custom/arrow-r-interact" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow-l-system" = {
        format = "";
        tooltip = false;
      };

      "custom/sep-system" = {
        format = "|";
        tooltip = false;
      };

      "custom/arrow-r-system" = {
        format = "";
        tooltip = false;
      };

      "custom/arrow-l-stats" = {
        format = "";
        tooltip = false;
      };

      "custom/sep-stats" = {
        format = "|";
        tooltip = false;
      };

      "custom/arrow-r-stats" = {
        format = "";
        tooltip = false;
      };
    }
  ];
}
