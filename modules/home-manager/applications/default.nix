{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./default-applications.nix
    ./desktop
    ./tui/direnv/direnv.nix
    ./tui/helix/helix.nix
    ./tui/neovim/neovim.nix
    ./tui/nix-index/nix-index.nix
    ./gui/citrix/citrix.nix
    ./gui/chromium/chromium.nix
    ./gui/flameshot/flameshot.nix
    ./gui/jetbrains/jetbrains.nix
    ./gui/kitty/kitty.nix
    ./gui/teams
    ./gui/nemo/nemo.nix
    ./gui/obsidian/obsidian.nix
    ./gui/tidal-hifi/tidal-hifi.nix
    ./gui/vscode/vscode.nix
    ./gui/webcord/webcord.nix
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
