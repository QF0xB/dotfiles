{
  lib,
  config,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkDefault
    ;
in
{
  options.qnix.applications.editors.jetbrains = {
    enable = mkEnableOption "jetbrains suite" // {
      default = !config.qnix.headless;
    };

    pycharm.enable = mkEnableOption "jetbrains python ide";

    writerside.enable = mkEnableOption "jetbrains documentation ide";

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

    qnix.applications.editors.jetbrains = {
      clion.enable = mkDefault true;
      pycharm.enable = mkDefault true;
    };

    qnix.persist.home = {
      directories = [
        ".config/JetBrains"
        ".local/share/JetBrains"
        ".java/.userPrefs"
        ".gradle"
        ".local/share/direnv/allow"
        ".config/github-copilot"
      ];
      cache.directories = [
        ".cache/JetBrains"
        ".cargo"
        ".cache/github-copilot"
      ];
    };
  };
}
