{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let 
  cfg = config.qnix.system.gnupg;
in with lib;
{
  options.qnix.system.gnupg = {
    enable = mkEnableOption "gnupg";
  };

  config = mkIf cfg.enable {
    programs = {

      gnupg = {
        agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };
    
      ssh.startAgent = false;
    };
  };
}
