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

  options.qnix.applications = with lib; {
    editor = mkOption {
      description = "Default Editor";
      default = pkgs.neovim;
      type = types.pkgs;
    };

  };

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
