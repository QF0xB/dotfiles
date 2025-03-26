{
  config,
  lib,
  ...
}:

let
  cfg = config.hm.qnix.system.security.u2f;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    hardware = {
      gpgSmartcards.enable = true;
    };

    services = {
      pcscd.enable = true;
    };

    security = {
      pam = {
        u2f = {
          enable = true;
        };

        services = {
          login.u2fAuth = true;
          sudo.u2fAuth = true;
        };
      };
    };
  };
}
