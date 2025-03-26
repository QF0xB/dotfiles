{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hm.qnix.hardware.yubikey;
in
{
  config = {
    programs.yubikey-touch-detector.enable = true;

    services.udev = {
      packages = with pkgs; [
        yubikey-personalization
      ];

      extraRules = lib.strings.concatStrings [
        ''
          # YubiKey 5 NFC udev rule for CCID interface (gpg --card-info)
          SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0407", ENV{ID_SECURITY_TOKEN}=="1", MODE="0660", GROUP="wheel"
          ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10ec", ATTR{device}=="0x8125", ATTR{power/control}="on" 
        ''
        (
          if cfg.autolock then
            ''
                # Autolocking when yubikey unplugged
              ACTION=="remove",\
                ENV{ID_BUS}=="usb",\
                ENV{ID_MODEL_ID}=="0407",\
                ENV{ID_VENDOR_ID}=="1050",\
                ENV{ID_VENDOR}=="Yubico",\
                RUN+="${pkgs.systemd}/bin/reboot"
            ''
          else
            ''''
        )
      ];

    };

    security = {
      pam = {
        u2f = {
          settings = {
            cue = true;
            origin = "pam://yubi";
          };
        };
      };
    };
  };
}
