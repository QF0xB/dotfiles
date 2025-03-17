{
  pkgs,
  ...
}:

{
  config = {
    home.packages = with pkgs; [ xdg-user-dirs ];
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        publicShare = null;
        desktop = null;
      };
    };

    qnix.persist.home = {
      cache.directories = [
        "cache-projects"
      ];
      directories = [
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
