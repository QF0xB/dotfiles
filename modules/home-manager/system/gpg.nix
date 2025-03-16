{
  lib,
  config,
  ...
}:

{
  config = {
    home.file.".gnupg/scdaemon.conf".text = ''
      disable-ccid
      debug-level guru
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
