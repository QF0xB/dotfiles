{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.security.gpg;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.security.gpg = {
    enable = mkEnableOption "gpg" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home = {
      file.".gnupg/scdaemon.conf".text = ''
        disable-ccid
        debug-level guru
      '';

      file.".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 60
        max-cache-ttl 120
        pinentry-program ${pkgs.pinentry-gnome3}/bin/pinentry
        ttyname $GPG_TTY
      '';

      activation.fixGpgHome = lib.mkAfter ''
        chmod 700 ${config.home.homeDirectory}/.gnupg
      '';
    };

    qnix.persist.home = {
      directories = [
        ".gnupg"
      ];
    };
  };
}
