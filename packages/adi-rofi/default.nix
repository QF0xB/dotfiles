{
  config,
  pkgs,
  lib,
  ...
}:

let
  rofi-themes = pkgs.stdenv.mkDerivation {
    pname = "rofi-adi1090x-themes";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      rev = "master";
      sha256 = "sha256-TVZ7oTdgZ6d9JaGGa6kVkK7FMjNeuhVTPNj2d7zRWzM=";
    };

    installPhase = ''
      mkdir -p $out/share/rofi-themes
      cp -r * $out/share/rofi-themes/
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    rofi
    rofi-themes
  ];

  # Create wrapper scripts for the themes
  environment.etc = {
    "rofi-launcher" = {
      text = ''
        #!/bin/sh
        THEME_DIR="/run/current-system/sw/share/rofi-themes/launchers/type-1"
        cd $THEME_DIR && ./launcher.sh
      '';
      mode = "0755";
    };

    "rofi-powermenu" = {
      text = ''
        #!/bin/sh
        THEME_DIR="/run/current-system/sw/share/rofi-themes/powermenu/type-1"
        cd $THEME_DIR && ./powermenu.sh
      '';
      mode = "0755";
    };
  };

  # Create symlinks to the scripts in /usr/bin
  system.activationScripts.rofiThemesSymlinks = ''
    mkdir -p /usr/bin
    ln -sf /etc/rofi-launcher /usr/bin/rofi-launcher
    ln -sf /etc/rofi-powermenu /usr/bin/rofi-powermenu
  '';
}
