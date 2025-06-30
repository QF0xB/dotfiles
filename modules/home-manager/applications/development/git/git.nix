{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.home.devel.git;
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in
{
  options.qnix.home.devel.git = {
    enable = mkEnableOption "git" // {
      default = config.qnix.development;
    };
    userName = mkOption {
      type = types.str;
      default = "Quirin Brändli";
    };
    userEmail = mkOption {
      type = types.str;
      default = "qbraendli@pm.me";
    };
    signing = mkEnableOption "git-signing" // {
      default = config.qnix.hardware.yubikey.enable;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gitflow
    ];
    programs.git = {
      inherit (cfg) enable userName userEmail;

      lfs.enable = true;

      signing = mkIf cfg.signing {
        key = "90360B7DB6B78B75E9013D113FF8C23C46F2CC90";
      };

      extraConfig.commit.gpgsign = cfg.signing;
    };
  };
}
