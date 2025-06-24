{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.communication.webcord;
in
{
  options.qnix.applications.communication.webcord = with lib; {
    enable = mkEnableOption "activate webcord" // {
      default = !config.qnix.headless;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # https://github.com/NixOS/nixpkgs/issues/385588
      # (webcord.override { electron = electron_32; })
      webcord
    ];

    qnix.persist.home.directories = [
      ".config/WebCord"
    ];
  };
}
