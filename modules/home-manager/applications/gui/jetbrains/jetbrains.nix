{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.gui.jetbrains;
  inherit (lib) mkEnableOption lists concatLists;
in
{
  options.qnix.applications.gui.jetbrains = {
    enable = mkEnableOption "jetbrains suite" // {
      default = !config.qnix.headless;
    };

    pycharm.enable = mkEnableOption "jetbrains python ide" // {
      default = !config.qnix.headless;
    };

    writerside.enable = mkEnableOption "jetbrains documentation ide" // {
      default = !config.qnix.headless;
    };

    webstorm.enable = mkEnableOption "jetbrains web ide";

    rust-rover.enable = mkEnableOption "jetbrains rust ide";

    rider.enable = mkEnableOption "jetbrains .NET ide";

    clion.enable = mkEnableOption "jetbrains C and C++ ide";

    datagrip.enable = mkEnableOption "jetbrains database ide";

    dataspell.enable = mkEnableOption "jetbrains data visualizer";

    idea.enable = mkEnableOption "jetbrains java ide" // {
      default = !config.qnix.headless;
    };
  };

  imports = [
    ./idea.nix
    ./clion.nix
    ./datagrip.nix
    ./dataspell.nix
    ./rider.nix
    ./pycharm.nix
    ./webstorm.nix
    ./rust-rover.nix
    ./writerside.nix
  ];

  config = {
    #    home.packages = with pkgs; [
    #      jetbrains-toolbox
    #    ];

    qnix.persist.home = {
      directories = [
        ".config/JetBrains"
      ];
      cache.directories = [
        ".cache/JetBrains"
      ];
    };
  };
}
