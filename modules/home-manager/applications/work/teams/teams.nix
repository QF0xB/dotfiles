{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.work.teams;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.work.teams = {
    enable = mkEnableOption "teams-for-linux" // {
      default = config.qnix.work;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ stable.teams-for-linux ];

    qnix.persist.home.directories = [ ".config/teams-for-linux" ];
  };
}
