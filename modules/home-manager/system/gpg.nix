{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = {
    home.file.".gnupg/scdaemon.conf".text = ''
      disable-ccid
      debug-level guru
    '';

    home.file.".gnupg/gpg-agent.conf".text = ''
      default-cache-ttl 60
      max-cache-ttl 120
      pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
      ttyname $GPG_TTY
    '';

    home.activation.fixGpgHome = lib.mkAfter ''
      chmod 700 ${config.home.homeDirectory}/.gnupg
    '';

    qnix.persist.home = {
      directories = [
        ".gnupg"
      ];
    };
  };
}
