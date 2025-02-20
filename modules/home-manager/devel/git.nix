{
  options, 
  lib,
  config,
  ... 
}:

let
  cfg = config.qnix.home.devel.git;
in with lib;
{
  options.qnix.home.devel.git = {
     enable = mkEnableOption "git";
     userName = mkOption { 
       type = types.lines;
       default = "Quirin Brändli"; 
     };
     userMailAddress = mkOption { 
       type = types.lines; 
       default = "qbraendli@pm.me"; 
     };
     signing = mkEnableOption "git-signing";
  };
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userMailAddress;
      
      lfs.enable = true;

      signing = mkIf cfg.signing {
        key = "90360B7DB6B78B75E9013D113FF8C23C46F2CC90";
      };

      extraConfig.commit.gpgsign = cfg.signing;
    };
  };
}
