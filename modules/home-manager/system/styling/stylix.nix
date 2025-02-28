{
  pkgs,
  ...
}:

{
  config = {
    stylix = {
      iconTheme = {
        enable = true;

        package = pkgs.zafiro-icons;
        dark = "zafiro-icons-dark";
        light = "zafiro-icons-light";
      };
    };
  };
}
