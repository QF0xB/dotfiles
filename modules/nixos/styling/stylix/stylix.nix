{
  lib,
  config,
  pkgs,
  isLaptop,
  ...
}:

let
  cfg = config.qnix.system.stylix;
in
{
  options.qnix.system.stylix = with lib; {
    enable = mkEnableOption "global styling with stylix" // {
      default = true;
    };
  };

  config = {
    stylix = {
      inherit (cfg) enable;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
      image = ./wallpapers/nix-wallpaper-nineish-solarized-dark.png;
      polarity = "dark";

      cursor = {
        package = pkgs.simp1e-cursors;
        name = "Simp1e-Solarized-Dark";
        size = 24;
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
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = if isLaptop then 12 else 16;
          desktop = if isLaptop then 12 else 16;
          popups = if isLaptop then 12 else 16;
          terminal = if isLaptop then 12 else 16;
        };
      };
    };
  };
}
