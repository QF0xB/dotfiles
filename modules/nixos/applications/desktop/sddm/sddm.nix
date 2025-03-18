{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.qnix.applications.general.sddm;

  Xsetup = pkgs.writeScript "Xsetup" ''
    xrandr --auto
    xrandr --output DP-4 --off
  '';
in
{
  options.qnix.applications.general.sddm = {
    enable = mkEnableOption "sddm display manager" // {
      default = !config.hm.qnix.headless;
    };
  };

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
