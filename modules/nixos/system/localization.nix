{
  options, 
  lib,
  config,
  ... 
}:

let
  cfg = config.qnix.system.localization;
in
{
  options.qnix = with lib; {
    system.localization = {
      dual-qkeyboard = mkEnableOption "Dual-QKeyboard";
      console-xkb-bridge = mkEnableOption "XKB to console keyboard config";
      english-german-locales = mkEnableOption "English-German mixed locales";
    };
  };

  config = {
    services.xserver = lib.mkIf cfg.dual-qkeyboard {
      xkb.layout = "de,us";
      xkb.variant = "koy,";
      # xkbOptions = "grp:win_space_toggle";
    };  
  
    console.useXkbConfig = cfg.console-xkb-bridge;

    i18n = lib.mkIf cfg.english-german-locales {
      supportedLocales = [
        "de_DE.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];
      extraLocaleSettings = {
        LANG = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
        LC_COLLATE = "en_US.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_MESSAGES = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_ADDRESS = "de_DE.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_IDENTIFICATION="en_US.UTF-8";
      };
    };
  };
}
