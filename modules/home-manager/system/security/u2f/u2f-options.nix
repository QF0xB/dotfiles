{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.qnix.system.security.u2f;
in
{
  options.qnix.system.security.u2f = {
    enable = mkEnableOption "u2f" // {
      default = config.qnix.hardware.yubikey.enable;
    };
  };

  config = mkIf cfg.enable {
    qnix.applications.shells.packages.gpg-reset-yubikey-id.text = ''
      echo "reset gpg to make new key available"
      set -x
      set -e
      ${pkgs.psmisc}/bin/killall gpg-agent
      rm -r ~/.gnupg/private-keys-v1.d/
      echo "now the new key should work"
    '';
  };
}
