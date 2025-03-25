{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.system.security;
in
with lib;
{
  options.qnix.system.security = {
    u2f.enable = mkEnableOption "u2f auth" // {
      default = true;
    };
    yubico.enable = mkEnableOption "yubico auth" // {
      default = true;
    };
  };

  config = {
    programs.yubikey-touch-detector.enable = true;
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];
    services.udev.extraRules = ''
      # YubiKey 5 NFC udev rule for CCID interface (gpg --card-info)
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0407", ENV{ID_SECURITY_TOKEN}=="1", MODE="0660", GROUP="wheel"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10ec", ATTR{device}=="0x8125", ATTR{power/control}="on"
    '';

    hardware.gpgSmartcards.enable = true;

    hm.qnix.applications.shells.packages.gpg-reset-yubikey-id.text = ''
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
            #            interactive = true;
            cue = true;
            origin = "pam://yubi";
          };
        };

        services = {
          login.u2fAuth = cfg.u2f.enable;
          sudo.u2fAuth = cfg.u2f.enable;
        };
      };
    };
    services.pcscd.enable = true;

    # write Yubico file
    hm = {
      xdg.configFile."Yubico/u2f_keys".text =
        "lcqbraendli:NVMp7RLgO9G+J8I+iC2mj0qum9xswAnnYQJU6btNuxcpVrPZFJr96Iwa2qBh2i+MnYc3o701kZLTPlkWd5ztyw==,N2cOgisG3QHs6DDees4w6nrZK2LOKZF6tZQkYGCJ6p52kQ5TG9hreCFBR68UliyOSg4FYinlRK57L0mtVejrbw==,es256,+presence";
    };
  };
}
