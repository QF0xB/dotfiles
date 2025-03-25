{
  config,
  isLaptop,
  ...
}:

{
  programs.waybar.style = ''
    /* Keyframes */ 
    @keyframes blink-critical {
      to {
        background-color: @critical;
      }
    }

    /* Styles */

    /* Colors (Solarized) */
    @define-color base03 #002b36;
    @define-color base02 #073642;
    @define-color base01 #586e75;
    @define-color base00 #657b83;
    @define-color base0 #839496;
    @define-color base1 #93a1a1;
    @define-color base2 #eee8d5;
    @define-color base3 #fdf6e3;
    @define-color yellow #b58900;
    @define-color orange #cb4b16;
    @define-color red #dc322f;
    @define-color magenta #d33682;
    @define-color violet #6c71c4;
    @define-color blue #268bd2;
    @define-color cyan #2aa198;
    @define-color green #859900;


    @define-color warning 	@yellow;
    @define-color critical	@red;
    @define-color system-settings	@violet;
    @define-color clock	@cyan;
    @define-color stats	@cyan;
    @define-color layout	@blue;

    @define-color workspace @violet;
    @define-color workspace-button @base03;
    @define-color workspace-button-active @orange;
    @define-color workspace-button-inactive @green;
    @define-color workspace-button-urgent @red;
    @define-color workspace-button-hover @base01;

    @define-color tray @blue;
    @define-color interact @blue;
    @define-color text @base03;

    /* Reset all styles */
    * {
    	border: none;
    	border-radius: 0;
    	min-height: 0;
    	margin: 0;
    	padding: 0;
    	box-shadow: none;
    	text-shadow: none;
    	icon-shadow: none;
    }

    /* Full bar */ 
    #waybar {
      background: transparent;
      color: @text;
      font-family: ${config.stylix.fonts.monospace.name};
      font-size: ${if isLaptop then "15pt" else "25pt"}; 
    }

    /* All modules */ 
    #battery,
    #clock, 
    #cpu,
    #language,
    #memory,
    #network,
    #pulseaudio,
    #temperature,
    #tray,
    #workspaces,
    #custom-logo,
    #custom-clipboard,
    #custom-notification, 
    #custom-yubikey,
    #custom-sep-interact,
    #custom-sep-system,
    #custom-sep-stats {
      padding-left: 5pt;
      padding-right: 5pt;      
      margin-top: ${if isLaptop then "10px" else "18px"};
    }

    /* All critical modules */
    #memory.critical,
    #cpu.critical,
    #temperature.critical,
    #battery.critical.discharging {
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-name: blink-critical;
      animation-duration: 2s;
    }

    /* All warning modules */
    #network.disconnected,
    #memory.warning,
    #cpu.warning,
    #temperature.warning,
    #battery.warning.discharging {
      color: @warning;
    }

    /* Category colors */

    #custom-side-spacer {
      padding-left: ${config.wayland.windowManager.hyprland.settings.general.gaps_out};
    }

    /* Clock */ 
    #clock {
      background: @clock;
    }

    #custom-arrow-l-clock,
    #custom-arrow-r-clock {
      color: @clock;
    }

    #custom-arrow-r-clock {
      padding-right: ${if isLaptop then "5px" else "15px"};
    }

    /* Workspaces */ 
    #workspaces {
      background-color: @workspace;
    }

    #workspaces button {
      padding-left: 2pt;
      padding-right: 2pt;
      color: @workspace-button;
      border-radius: 100px;
      font-weight: normal;
    }

    /* Inactive tab */ 
    #workspaces button.visible {
      background: @workspace-button-inactive;
      color: @workspace;
    }    
    /* Active tab */ 
    #workspaces button.visible {
      background: @workspace-button-active;
      color: @text;
    }

    /* Urgent tab */
    #workspaces button.urgent {
      color: @workspace;
      background: @workspace-button-urgent;
    }

    #workspaces button:hover {
      background: @workspace-button-hover;
    }

    #custom-arrow-l-work,
    #custom-arrow-r-work {
      color: @workspace;
    }

    #custom-arrow-r-work {
      padding-right: ${if isLaptop then "5px" else "15px"};
    }

    /* Tray */
    #tray,
    #custom-yubikey {
      background-color: @tray;
    }

    #custom-arrow-l-tray {
      color: @tray;
    }

    #custom-arrow-r-tray{
      padding-right: ${if isLaptop then "5px" else "15px"};
      color: @tray;
    }

    /* Interactive settings */ 
    #custom-sep-interact,
    #custom-clipboard,
    #language {
      background: @interact;
    }

    #custom-arrow-r-interact {
      padding-right: ${if isLaptop then "5px" else "15px"};
    }

    #custom-arrow-l-interact,
    #custom-arrow-r-interact {
      color: @interact;
    }

    /* System Settings */
    #custom-sep-system,
    #backlight,
    #network,
    #pulseaudio {
      background: @system-settings;
    }

    #custom-arrow-r-system {
      padding-right: ${if isLaptop then "5px" else "15px"};
    }

    #custom-arrow-l-system,
    #custom-arrow-r-system {
      color: @system-settings;
    }

    /* Stats */ 
    #custom-sep-stats,
    #custom-notification,
    #cpu,
    #temperature,
    #memory,
    #battery {
      background: @stats;
    }

    #custom-arrow-l-stats,
    #custom-arrow-r-stats {
      color: @stats;
    }

    /* Arrows and separators */ 
    #custom-arrow-l-clock,
    #custom-arrow-r-clock,
    #custom-arrow-l-work,
    #custom-arrow-r-work,
    #custom-arrow-l-tray,
    #custom-arrow-r-tray,
    #custom-arrow-l-interact,
    #custom-arrow-r-interact,
    #custom-arrow-l-system,
    #custom-arrow-r-system,
    #custom-arrow-l-stats,
    #custom-arrow-r-stats {
      margin-top: ${if isLaptop then "10px" else "18px"};
    }
  '';
}
