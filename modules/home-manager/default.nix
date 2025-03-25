{
  user,
  ...
}:

{
  imports = [
    ./applications
    ./default-options.nix
    ./hardware
    ./nix
    ./styling
    ./system
  ];

  config = {
    home = {
      username = user;
      homeDirectory = "/home/${user}";

      # Do NOT change
      stateVersion = "24.11";
    };
  };
}
