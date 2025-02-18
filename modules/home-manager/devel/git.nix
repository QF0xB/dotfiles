{
  options, 
  lib,
  config,
  ... 
}:

let
  cfg = config.qnix.home.devel.git;
in
{
  options.qnix = with lib; {
     home.devel.git.enable = mkEnableOption "git";
     home.devel.git.userName = mkOption { 
       type = types.lines;
       default = "Quirin Brändli"; 
     };
     home.devel.git.userMailAddress = mkOption { 
       type = types.lines; 
       default = "qbraendli@pm.me"; 
     };
  };
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userMailAddress;
      
      lfs.enable = true;
    };
  };
}
