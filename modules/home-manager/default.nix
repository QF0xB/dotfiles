{
  user,
  ...
}:

{
  imports = [
    ./impermanence.nix #only contains options
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
