{
  options, 
  lib,
  config,
  ... 
}:

let
  cfg = config.qnix;
in
{
  config = {
    home.file.".gnupg/scdaemon.conf".text = ''
      # NOT USING PCSCD ANYMORE disable-ccid
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

