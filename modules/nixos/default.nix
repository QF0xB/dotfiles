{ inputs, ... }:

{
  imports = [
    ./nix
    ./system
    ./users
    ./applications
  ];
}
