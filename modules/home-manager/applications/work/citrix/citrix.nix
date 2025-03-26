{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.work.citrix;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.work.citrix = {
    enable = mkEnableOption "citrix workspace" // {
      default = config.qnix.work;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (citrix_workspace.override {
        extraCerts = [
          ./kjr_network.cert
        ];
      })
    ];
  };
}
