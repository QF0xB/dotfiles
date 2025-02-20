{
  user,
  lib,
  ...
}:

{
  imports = [
    ./git.nix
  ];

  config = with lib; {
    qnix.home = {
      devel.git = {
        enable = mkDefault true;
        signing = mkDefault true;
      };
    };
  };
}
