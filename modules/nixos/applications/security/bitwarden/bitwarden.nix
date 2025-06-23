{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.security.bitwarden;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.security.bitwarden = {
    enable = mkEnableOption "bitwarden" // {
      default = !config.hm.qnix.headless;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bitwarden-desktop
    ];
  };
}
