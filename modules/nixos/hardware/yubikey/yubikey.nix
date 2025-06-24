{
  config,
  lib,
  pkgs,
  user,
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
            authfile = pkgs.writeText "u2f-mappings" (
              lib.concatStrings [
                user
                ":WL1eNX3H4cqCpOdlFLskeKHVkf+SUVng34Ch6rxwn5gw+bJrTyH7wBaYE/iY0Rl4Ab0mNJrTtoUqjLaRNvhWbA==,DX5g1dye2T+mX8tNyMg05W3NrbDE527OCWv6BcUgb63H0zEu4BEl9zWlf3tVOINlqyHcS988QVzfzfHKXT5Abw==,es256,+presence"
                ":9pemD5VMkbFx9OVcu9TWGkqT8kT7j0ep5IW1dMn/iMQ1xlgud7bApcEnuq70TSCC31SRW2xJhPGZCIo0RFH9fA==,n5t5J7xVYOyJs7GcHveOaw2DSnQEdhBjtd6iQ/VSQjw81kg/R61+CxpZINI6gE1PHNaFz8xoZUXgGQUu7ppFbw==,es256,+presence"
              ]
            );
          };
        };
      };
    };
  };
}
