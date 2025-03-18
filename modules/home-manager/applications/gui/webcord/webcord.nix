{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.gui.webcord;
in
{
  options.qnix.applications.gui.webcord = with lib; {
    enable = mkEnableOption "activate webcord" // {
      default = !config.qnix.headless;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # https://github.com/NixOS/nixpkgs/issues/385588
      (webcord.override { electron = electron_32; })
    ];

    qnix.persist.home.directories = [
      ".config/WebCord"
      "WebCord"
      ".config/goxlr-utility"
      ".local/state/wireplumber"
      ".local/share/goxlr-utility"
    ];
  };
}
