{
  ...
}:

{
  config = {
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        publicShare = null;
        desktop = null;
      };
    };

    qnix.persist = {
      home.directories = [
        "Music"
        "Videos"
        "Templates"
        "Downloads"
        "Documents"
        "Pictures"
      ];
    };
  };
}
