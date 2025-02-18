{
  user,
  ...
}:

{
  imports = [
    ./nix
    ./devel
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
