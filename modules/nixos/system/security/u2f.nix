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
    services.udev.packages = with pkgs; [ yubikey-personalization pcsclite ];
    services.udev.extraRules = ''
      # YubiKey 5 NFC udev rule for CCID interface (gpg --card-info)
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0407", ENV{ID_SECURITY_TOKEN}=="1", MODE="0660", GROUP="wheel"
    '';

    hardware.gpgSmartcards.enable = true;

    qnix.system.shell.packages.gpg-reset-yubikey-id.text = ''
      echo "reset gpg to make new key available"
      set -x
      set -e
      ${pkgs.psmisc}/bin/killall gpg-agent
      rm -r ~/.gnupg/private-keys-v1.d/
      echo "now the new key should work"
    '';

    
    security = {
      pam = {
        u2f = {
          enable = cfg.u2f.enable;
          settings = {
            interactive = true;
            cue = true;
          };
        };

        services = {
          login.u2fAuth = cfg.u2f.enable;
          sudo.u2fAuth = cfg.u2f.enable;
        }; 
      };
    };
    services.pcscd.enable = false;

    # write Yubico file
    hm = { 
      xdg.configFile."Yubico/u2f_keys".text = "lcqbraendli:J5hP5H75BENH4dYh/1N45EsgtcQqjRAk+UH3u6Kv/fMPJE000JR0ZJWzu7yBoO7U6AuHRKE5BeKuy2wxhJqK5w==,SI7JOMqaHX3K3d9Hn+tPc5myTh9Br9YJqzzFCNAYVeMwS4wkLrptWep+7m4/P//+HDwuAwvScvx6M3zVCezKLQ==,es256,+presence";
    };
  };
}
