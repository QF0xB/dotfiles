{
  lib,
  config,
  user,
  ...
}:

let
  cfg = config.hm.qnix.hardware.screen;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    programs.light = {
      enable = true;
      brightnessKeys = {
        enable = true;
        step = 10;
      };
    };

    users.users.${user}.extraGroups = [
      "video"
    ];

    qnix.persist = {
      root.directories = [ "/etc/light" ];
      home.directories = [ ".config/light" ];
    };
  };
}
