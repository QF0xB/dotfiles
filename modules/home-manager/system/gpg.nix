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

    qnix.persist.home = {
        directories = [
          ".gnupg"  
        ];
      };
  };
}

