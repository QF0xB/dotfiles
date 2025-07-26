{
  lib,
  isLaptop,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption;
  cfg = config.qnix.hardware.yubikey;

  yubikeyNotifyHandler = pkgs.writeShellScriptBin "yubikey-autolock-handler" ''
    #!/bin/sh
    COUNTDOWN=${toString cfg.delaySeconds}
    FLAG_FILE="$XDG_RUNTIME_DIR/yubikey-reboot-cancelled"

    # If laptop + not charging → immediate reboot
    ${lib.optionalString isLaptop ''
      ON_AC=$(grep 1 /sys/class/power_supply/AC*/online 2>/dev/null | wc -l)
      if [ "$ON_AC" -eq 0 ]; then
        logger -t yubikey "Laptop on battery — immediate reboot."
        exec systemctl reboot
      fi
    ''}

    export FLAG_FILE

    ${pkgs.swaynotificationcenter}/bin/swaync-client -m |
      while read -r line; do
        if echo "$line" | grep -q "cancel-reboot"; then
          echo "Button received, touching $FLAG_FILE" | systemd-cat -t yubikey
          /usr/bin/touch "$FLAG_FILE"
        fi
      done &

    ${pkgs.libnotify}/bin/notify-send --app-name="YubiLock" \
      --action=cancel-reboot=Cancel Reboot \
      -u critical -t $((COUNTDOWN * 1000 * 1)) \
      "YubiKey removed" \
      "System will reboot in $COUNTDOWN seconds unless you click Cancel Reboot."

    sleep "$COUNTDOWN"

    ls -l /run/user/$(id -u) | logger -t yubikey

    if [ -f "$FLAG_FILE" ]; then
      logger -t yubikey "Reboot cancelled by user action."
      notify-send -u normal "YubiKey reboot cancelled."
      rm -f "$FLAG_FILE"
      exit 0
    fi

    logger -t yubikey "Countdown expired — rebooting now."
    systemctl reboot

  '';

  cancelNextReboot = pkgs.writeShellScriptBin "cancel-next-yubikey-reboot" ''
    #!/bin/sh
    RUNTIME="/run/user/$(id -u)"
    FLAG="$RUNTIME/yubikey-reboot-cancelled"
    echo "$(date) cancel-next-yubikey-reboot called, writing to $FLAG" | systemd-cat -t cancel-next
    touch "$FLAG"
    notify-send -u normal "Next YubiKey reboot cancelled"
  '';

in
{
  options.qnix.hardware.yubikey = {
    enable = mkEnableOption "yubikey support" // {
      default = true;
    };

    autolock = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable automatic reboot when YubiKey is removed.";
    };

    delaySeconds = lib.mkOption {
      type = lib.types.int;
      default = 15;
      description = "Delay before rebooting (in seconds) after YubiKey removal.";
    };
  };

  config = {
    systemd.user.services."yubikey-autolock" = {
      Unit = {
        Description = "YubiKey autolock reboot handler";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${yubikeyNotifyHandler}/bin/yubikey-autolock-handler";
        PrivateTmp = false;
        ProtectSystem = false;
        ProtectHome = false;
      };
    };

    home.packages = [
      yubikeyNotifyHandler
      cancelNextReboot
    ];
  };

  # config = {
  # write Yubico file
  # xdg.configFile."Yubico/u2f_keys".text = ''
  # lcqbraendli:WL1eNX3H4cqCpOdlFLskeKHVkf+SUVng34Ch6rxwn5gw+bJrTyH7wBaYE/iY0Rl4Ab0mNJrTtoUqjLaRNvhWbA==,DX5g1dye2T+mX8tNyMg05W3NrbDE527OCWv6BcUgb63H0zEu4BEl9zWlf3tVOINlqyHcS988QVzfzfHKXT5Abw==,es256,+presence
  # lcqbraendli:m0YQcNcDr6IuR4uyZPsfGIH5cyXTQ83xMDwGGXfcHm1cYKBlYW0Vk2iM2OgIGFC4RhoC0fxNf2xzS4JQxZJ8+A==,larZDQZG5KERhbGuWutQyokSA/fcCWlnff4K32SCIOvj4e8PI2EnjCY7q5KsAuGQEdurx0PVayHltNhWW54Hyg==,es256,+presence
  # '';

  # };
}
