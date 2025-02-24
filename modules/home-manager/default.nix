{
  user,
  ...
}:

{
  imports = [
    ./default-options.nix
    ./nix
    ./devel
    ./system
    ./applications
    ./style
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
