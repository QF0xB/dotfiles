{
  user,
  ...
}:

{
  imports = [
    ./backup.nix
    ./ssh.nix
    ./shells
    ./gpg.nix
    ./styling/stylix.nix
    ./xdg-folders.nix
  ];

  config = {

  };
}
