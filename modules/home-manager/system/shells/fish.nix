{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) getExe mkForce mkEnableOption;
  fishPath = getExe config.programs.fish.package;
  cfg = config.qnix.home.system.shell.fish;
in
{

  options.qnix.home.system.shell.fish = {
    enable = mkEnableOption "fish";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      fish = {
        enable = true;
        preferAbbrs = true;
        shellAbbrs = config.home.shellAliases;
        shellInit = ''
          # shut up welcome message
          set fish_greeting

          # set options for plugins
          set sponge_regex_patterns 'password|passwd|^kill'
        '';
      };

      #      kitty = {
      #        settings = {
      #          env = "SHELL=${fishPath}";
      #          shell = mkForce (getExe config.programs.fish.package);
      #        };
      #      };

      #      ghostty = {
      #        settings = {
      #          command = mkForce "SHELL=${fishPath} ${fishPath}";
      #        };
      #      };
    };

    home.packages = with pkgs.fishPlugins; [
      sponge
    ];

    qnix.persist = {
      home = {
        cache.directories = [ ".local/share/fish" ];
      };
    };
  };
}
