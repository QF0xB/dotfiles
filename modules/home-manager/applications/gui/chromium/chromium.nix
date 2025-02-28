{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.gui.chromium;
  inherit (lib) getExe;
  pack = pkgs.${cfg.version};
in
{
  options.qnix.applications.gui.chromium = with lib; {
    enable = mkEnableOption "chromium browser" // {
      default = !config.qnix.headless;
    };
    version = mkOption {
      type = types.str;
      description = "Version of Chromium to use.";
      example = "brave, chromium, vivaldi or google-chrome";
      default = "brave";
    };
  };

  config = {
    programs.chromium = {
      enable = cfg.enable;
      package = pack;

      commandLineArgs = [
        "--disable-features=AIChat,BraveVPN,Ipfs,BraveNativeWallet,BraveRewards"
      ];

      extensions = [
        # Bitwarden
        { id = "nngceckbapebfimnlniiiahkandclblb"; }
        # Dark Reader
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
        # JSON Viewer
        { id = "gbmdgpbipfallnflgajpaliibnhdgobh"; }
        # Old Reddit Redirect
        { id = "dneaehbmnbhcippjikoajpoabadpodje"; }
        # Reddit Enhancement Suite
        { id = "kbmfpngjjgdllneeigpgjifpgocmfgmb"; }
        # Return YouTube Dislike
        { id = "gebbhagfogifgggkldgodflihgfeippi"; }
        # SponsorBlock for YouTube - Skip Sponsorships
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
        # Surfingkeys
        { id = "gfbliohnnapiefjpjlpjnehglfpaknnc"; }
        # uBlock Origin
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      ];
    };
    # set default browser
    home.sessionVariables = {
      DEFAULT_BROWSER = getExe pack;
      BROWSER = getExe pack;
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = "${cfg.version}.desktop";
      "x-scheme-handler/http" = "${cfg.version}.desktop";
      "x-scheme-handler/https" = "${cfg.version}.desktop";
      "x-scheme-handler/about" = "${cfg.version}.desktop";
      "x-scheme-handler/unknown" = "${cfg.version}.desktop";
    };

    wayland.windowManager.hyprland.settings.windowrulev2 = [
      # do not idle while watching videos
      "idleinhibit fullscreen,class:^(${cfg.version})$"
      "idleinhibit focus,class:^(${cfg.version})$,title:(.*)(YouTube)(.*)"
      # float save dialogs
      # save as
      "float,initialClass:^(${cfg.version})$,initialTitle:^(Save File)$"
      "size <50% <50%,initialClass:^(${cfg.version})$,initialTitle:^(Save File)$"
      # save image
      "float,initialClass:^(${cfg.version})$,initialTitle:(.*)(wants to save)$"
      "size <50% <50%,initialClass:^(${cfg.version})$,initialTitle:(.*)(wants to save)$"
    ];

    qnix.persist = {
      home.directories = [
        ".cache/BraveSoftware"
        ".config/BraveSoftware"
      ];
    };
  };
}
