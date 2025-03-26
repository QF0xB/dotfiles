{
  options,
  lib,
  config,
  ...
}:

let
  cfg = config.hm.qnix.applications.connection.openssh;
in
{
  config = {
    services.openssh = {
      inherit (cfg) enable;

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
