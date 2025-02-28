{
  lib,
  config,
  ...
}:

{
  config = lib.mkIf config.hm.qnix.applications.gui.chromium.enable {
    programs.chromium = {
      enable = true;

      extraOpts = {
        BraveWalletDisabled = true;
        BraveRewardsDisabled = true;
        BraveVPNDisabled = true;
        BraveAIChatEnabled = false;
      };
    };
  };
}
