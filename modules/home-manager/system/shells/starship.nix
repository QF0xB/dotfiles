{
  lib,
  config,
  options,
  ...
}:

let
  cfg = config.qnix.home.system.shell.starship;
  inherit (lib) mkAfter concatStrings;
in
{
  options.qnix.home.system.shell.starship = with lib; {
    enable = mkEnableOption "starship shell";
  };

  config = {
    programs = {
      starship = {

        enable = cfg.enable;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableTransience = true;

        settings =
          let
            color = config.qnix.home.style.colors.${config.qnix.home.style.colors.scheme};
            text = "fg:${color.base03}";
          in
          {
            add_newline = false;
            format = concatStrings [
              # begin left format
              "$username"
              "[](${color.violet})"

              "[](${color.cyan})"
              "$hostname"
              "[](${color.cyan})"

              "[](${color.blue})"
              "$directory"
              "[](${color.blue})"

              "[](${color.green})"
              "$git_branch"
              "$git_state"
              "$git_status"
              "$nix_shell"
              "[](${color.green})"
              # end left format
              "$fill"
              # begin right format
              "[](${color.violet})"
              "$time"
              # end right format
              "$line_break"
              "$character"
            ];

            # modules
            character = {
              error_symbol = "[ ](bold red)";
              success_symbol = "[](purple)";
              vimcmd_symbol = "[](green)";
            };
            username = {
              style_root = "bg:${color.violet} fg:bold ${color.base03}";
              style_user = "bg:${color.violet} fg:bold ${color.base03}";
              format = concatStrings [
                "[ $user@ ]($style)"
              ];
              show_always = true;
            };
            hostname = {
              style = "bg:${color.cyan} ${text}";
              ssh_symbol = "󰣀 ";
              ssh_only = false;
              format = "[ $ssh_symbol$hostname ]($style)";
            };
            directory = {
              format = "[ $path ]($style)";
              truncation_length = 1;
              style = "bg:${color.blue} ${text}";
            };
            git_branch = {
              symbol = "";
              format = "[ $symbol $branch ]($style)";
              style = "bg:${color.green} ${text}";
            };
            git_state = {
              format = "( [$state( $progress_current/$progress_total)]($style))";
              style = "bg:${color.green} ${text}";
            };
            git_status = {
              format = "[($all_status$ahead_behind)]($style)";
              style = "bg:${color.green} ${text}";
            };
            nix_shell = {
              format = "[ $symbol ]($style)";
              symbol = "";
              style = "bg:${color.green} fg:bold ${color.base03}";
            };
            fill = {
              symbol = " ";
            };
            line_break = {
              disabled = false;
            };
            time = {
              format = "[ $time ]($style)";
              disabled = false;
              time_format = " %H:%M";
              style = "bg:${color.violet} ${text}";
            };
          };
      };

      fish = {
        # fix starship prompt to only have newlines after the first command
        # https://github.com/starship/starship/issues/560#issuecomment-1465630645
        shellInit = # fish
          ''
            function prompt_newline --on-event fish_postexec
              echo ""
            end
          '';
        interactiveShellInit =
          # fish
          mkAfter ''
            function starship_transient_prompt_func
              starship module character
            end
          '';
      };

      # some sort of race condition with kitty and starship
      #   https://github.com/kovidgoyal/kitty/issues/4476#issuecomment-1013617251
      kitty.shellIntegration.enableBashIntegration = false;
    };
  };
}
