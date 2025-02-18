{
  user,
  ...
}:

{
  imports = [
    ./git.nix
  ];

  config = {
    qnix.home = {
      devel.git.enable = true;
    };
  };
}
