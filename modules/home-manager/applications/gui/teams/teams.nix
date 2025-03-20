{
  config,
  lib,
  pkgs,
  host,
  ...
}:

let
  cfg = config.qnix.applications.gui.teams;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.gui.teams = {
    enable = mkEnableOption "teams-for-linux" // {
      default = (host == "QPC");
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ stable.teams-for-linux ];

    qnix.persist.home.directories = [ ".config/teams-for-linux" ];
  };
}
