{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./default-applications.nix
    ./tui/helix/helix.nix
    ./tui/neovim/neovim.nix
    ./general/hyprsuite/hyprsuite.nix
    ./general/rofi/rofi.nix
    ./general/swaync/swaync.nix
    ./general/waybar/waybar.nix
    ./gui/chromium/chromium.nix
    ./gui/kitty/kitty.nix
    ./gui/nemo/nemo.nix
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
      webcord # Discord
    ];

    qnix.applications = {
      tui = {

        neovim = {
          enable = mkDefault true;
          default = mkDefault true;
        };
      };

      general = {
        rofi.enable = mkDefault true;
      };
    };
  };
}
