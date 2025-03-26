{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./audio
    ./browsers
    ./communication
    ./connection
    ./default-applications.nix
    ./design
    ./desktop
    ./development
    ./editors
    ./security
    ./shells
    ./utils
    ./virtualisation
    ./work
    ./tui/nix-index/nix-index.nix
  ];

  options.qnix.applications = with lib; {
    editor = mkOption {
      description = "Default Editor";
      default = pkgs.neovim;
      type = types.pkgs;
    };
  };

  config = with lib; {
    home.packages = with pkgs; [
      dysk # better disk info
      ets # timestamps before each line
      fd # better find
      fx # json viewer
      jq # another json viewer
      wev # keyboard analyzer
      nwg-displays
      bash
    ];

    qnix.applications = {
    };

    qnix.persist.home.files = [
      ".config/hypr/workspaces.conf"
      ".config/hypr/monitors.conf"
    ];
  };
}
