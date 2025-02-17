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

    qnix.persist = {
      root = {
        files = [
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];
      };
    };
  };
}
