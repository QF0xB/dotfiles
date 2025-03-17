{
  lib,
  config,
  isLaptop,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.citrix;
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.citrix = {
    enable = mkEnableOption "citrix workspace" // {
      default = !isLaptop;
    };
  };

  config = {
    home.packages = with pkgs; [ citrix_workspace ];
  };
}
