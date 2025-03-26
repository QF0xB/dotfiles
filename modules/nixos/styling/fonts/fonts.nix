{
  options,
  config,
  pkgs,
  lib,
  ...
}:

{
  options.qnix.system = with lib; {
    fonts = {
      regular = mkOption {
        type = types.str;
        default = "Geist Regular";
        description = "The regular font for text";
      };
      monospace = mkOption {
        type = types.str;
        default = "Jetbrains Nerd Font";
        description = "Font to use with monospace text";
      };
      packages = mkOption {
        type = types.listOf types.package;
        description = "The font-packages to install on system";
      };
    };
  };

  config = with lib; {
    qnix.system.fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.jetbrains-mono
    ];

    fonts = {
      enableDefaultPackages = true;
      inherit (config.qnix.system.fonts) packages;
    };
  };
}
