{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.system.stylix;
in
{
  options.qnix.system.stylix = with lib; {
    enable = mkEnableOption "global styling with stylix";
  };

  config = {
    stylix = {
      enable = cfg.enable;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
      image = ./wallpapers/main-wallpaper.png;
      polarity = "dark";

      cursor = {
        package = pkgs.simp1e-cursors;
        name = "Simp1e-Solarized-Dark";
      };

      fonts = {
        serif = {
          package = pkgs.fira-sans;
          name = "Fira Sans";
        };

        sansSerif = {
          package = pkgs.fira-sans;
          name = "Fira Sans";
        };

        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "Fira Code";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
