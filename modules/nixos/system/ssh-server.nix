{
  options, 
  lib,
  config,
  ... 
}:

let
  cfg = config.qnix.system.openssh;
in
{
  options.qnix = with lib; {
    system.openssh.enable = mkEnableOption "ssh-server";
    system.openssh.password-auth = mkEnableOption "passwordauth";
  };

  config = {
    services.openssh = {
      enable = cfg.enable;
      
      settings.PasswordAuthentication = cfg.password-auth;
    };
  };
}
