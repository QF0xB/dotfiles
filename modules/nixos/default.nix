{ inputs, ... }:

{
  imports = [
    ./system
    ./users
    ./nix
    ./applications
  ];
}
