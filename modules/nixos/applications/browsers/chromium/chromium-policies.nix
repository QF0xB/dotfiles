{
  lib,
  config,
  ...
}:

let
  cfg = config.hm.qnix.applications.browsers.chromium;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;

      extraOpts = {
        BraveWalletDisabled = true;
        BraveRewardsDisabled = true;
        BraveVPNDisabled = true;
        BraveAIChatEnabled = false;
        RestoreOnStartup = true;
      };
    };
  };
}
