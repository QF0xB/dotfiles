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
  askpass = pkgs.writeShellScript "git-askpass" ''
    #!${pkgs.bash}/bin/bash
    PROMPT="${"1:-Password:"}"
    exec ${pkgs.zenity}/bin/zenity --entry --hide-text --title="Git Credential" --text="$PROMPT"
  '';
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
      zenity
    ];
    programs.git = {
      inherit (cfg) enable;

      lfs.enable = true;

      signing = mkIf cfg.signing {
        key = "90360B7DB6B78B75E9013D113FF8C23C46F2CC90";
      };

      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
        core.askpass = "${askpass}";
        credential.helper = "";
        commit.gpgsign = cfg.signing;
      };

    };
  };
}
