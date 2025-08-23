{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.qnix.applications.utils.docker;
in
{
  options.qnix.applications.utils.docker = {
    enable = mkEnableOption "docker" // {
      default = false;
    };
  };

  config = mkIf cfg.enable {
    qnix.persist.home.directories = [
      ".local/share/docker/volumes"
    ];
  };
}
