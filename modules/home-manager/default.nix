{
  user,
  ...
}:

{
  imports = [
    ./nix
    ./devel
    ./system
    ./programs
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
