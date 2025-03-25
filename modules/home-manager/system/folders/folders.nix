{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.qnix.system.folders;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.system.folders = {
    enable = mkEnableOption "create and persist folders" // {
      default = true;
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ xdg-user-dirs ];

    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        publicShare = null;
        desktop = null;
      };
    };

    qnix.persist.home = {
      cache.directories = [
        "cache-projects"
      ];
      directories = [
        "Music"
        "Videos"
        "Templates"
        "Downloads"
        "Documents"
        "Pictures"
      ];
    };
  };
}
