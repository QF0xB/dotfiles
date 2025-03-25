{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.hm.qnix.applications.desktop.sddm;

  Xsetup = pkgs.writeScript "Xsetup" ''
    xrandr --auto
    xrandr --output DP-4 --off
  '';
in
{
  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        (sddm-astronaut.override {
          embeddedTheme = "black_hole";
        })
        # Needed for astronaut theme
        kdePackages.qtmultimedia
      ];
    };

    services = {
      xserver.enable = true;
      displayManager.sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "sddm-astronaut-theme";
        settings = {
          X11 = {
            DisplayCommand = "${Xsetup}";
          };
        };
        #      wayland.enable = true;
      };
    };

  };
}
