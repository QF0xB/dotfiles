{
  user,
  lib,
  config,
  ...
}:

{
  imports = [
    ./tui/helix/helix.nix
    ./tui/neovim/neovim.nix
    ./general/hyprsuite/hyprsuite.nix
    ./general/rofi/rofi.nix
  ];

  options.qnix.applications = with lib; {
    editor = mkOption {
      description = "Default Editor";
      default = pkgs.neovim;
      type = types.pkgs;
    };
  };

  config = with lib; {
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
