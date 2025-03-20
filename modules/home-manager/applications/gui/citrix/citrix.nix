{
  lib,
  config,
  isLaptop,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.citrix;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.citrix = {
    enable = mkEnableOption "citrix workspace" // {
      default = !isLaptop;
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
