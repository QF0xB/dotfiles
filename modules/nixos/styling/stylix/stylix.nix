{
  config,
  pkgs,
  lib,
  isLaptop,
  ...
}:

let
  cfg = config.qnix.styling.stylix;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.styling.stylix = {
    enable = mkEnableOption "stylix style manager" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      overlays.enable = false;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
      image = ./wallpapers/nix-wallpaper-nineish-solarized-dark.png;
      polarity = "dark";

      # Fix issues with overlays: https://github.com/danth/stylix/issues/865
      targets.gnome-text-editor.enable = lib.mkForce false;

      cursor = {
        package = pkgs.simp1e-cursors;
        name = "Simp1e-Solarized-Dark";
        size = 24;
      };

      opacity = {
        applications = 0.5;
        terminal = 0.5;
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
