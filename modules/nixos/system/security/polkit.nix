{
  options,
  lib,
  config,
  user,
  pkgs,
  ...
}:

let
  cfg = config.qnix.system.security;
in
with lib;
{
  options.qnix.system.security = {
    polkit.enable = mkEnableOption "polkit";
  };

  config = {
    security = {
      polkit.enable = cfg.polkit.enable;

      polkit.extraConfig = ''
              polkit.addRule(function(action, subject) {
                if (
                  subject.isInGroup("users")
                    && (
                      action.id == "org.freedesktop.login1.reboot" ||
                      action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                      action.id == "org.freedesktop.login1.power-off" ||
                      action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                    )
                  )
                {
                  return polkit.Result.YES;
                }
              });
        polkit.addRule(function(action, subject) {
          if (action.id == "org.debian.pcsc-lite.access_card") {
            return polkit.Result.YES;
          }
        });

        polkit.addRule(function(action, subject) {
          if (action.id == "org.debian.pcsc-lite.access_pcsc") {
            return polkit.Result.YES;
          }
        });
      '';

      # Typo prevention
      sudo.extraConfig = "Defaults passwd_tries=5";
    };
  };
}
