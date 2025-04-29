{
  dots,
  ...
}:

{
  config = {
    home = {
      shellAliases = {
        c = "clear";
        dots = "cd ${dots}";
        ls = "clear && lsd -l";
        lss = "lsd -la";
        lsa = "clear && lsd -la";
        mime = "xdg-mime query filetype";
        mkdir = "mkdir -p";
        mount = "mount --mkdir";
        open = "xdg-open";

        # Git
        ga = "git add .";
        gc = "git commit";
        gp = "git push";

        # NIX
        nhs = "nh os switch ${dots}";

        # cd aliases
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";

        # Edit commands
        "nvd" = "nvim default.nix";

        # nix-gens
        "ngo" = "nix-gen-options";
        "ngeo" = "nix-gen-enable-options";
        "ngc" = "nix-gen-config";
        "ngco" = "nix-gen-config-options";
        "ngi" = "nix-gen-imports";
      };
    };
  };
}
