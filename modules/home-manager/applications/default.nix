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
  ];

  config = with lib; {
    qnix.home.applications = {
      tui = {

        neovim = {
          enable = mkDefault true;
          default = mkDefault true;
        };
      };
    };
  };
}
