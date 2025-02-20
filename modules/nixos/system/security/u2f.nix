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
in with lib;
{
  options.qnix.system.security = {
    u2f.enable = mkEnableOption "u2f auth";
    yubico.enable = mkEnableOption "yubico auth";
  };

  config = {
    services.udev.packages = [ pkgs.yubikey-personalization ];
    
    security = {
      pam = {
        u2f = {
          enable = cfg.u2f.enable;
        };

        services = {
          login.u2fAuth = cfg.u2f.enable;
          sudo.u2fAuth = cfg.u2f.enable;
        }; 
      };
    };

    # write Yubico file
    hm = { 
      xdg.configFile."Yubico/u2f_keys".text = "lcqbraendli:J5hP5H75BENH4dYh/1N45EsgtcQqjRAk+UH3u6Kv/fMPJE000JR0ZJWzu7yBoO7U6AuHRKE5BeKuy2wxhJqK5w==,SI7JOMqaHX3K3d9Hn+tPc5myTh9Br9YJqzzFCNAYVeMwS4wkLrptWep+7m4/P//+HDwuAwvScvx6M3zVCezKLQ==,es256,+presence";
    };
  };
}
