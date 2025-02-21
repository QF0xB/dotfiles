{ 
  dots,
  config,
  ...
}:

{
  config = {
    home = {
      shellAliases = {
        c = "clear";
        dots = "cd ${dots}";
        ls = "clear && lsd -la";
        lss = "lsd -la";
        mime = "xdg-mime query filetype";
        mkdir = "mkdir -p";
        mount = "mount --mkdir";
        open = "xdg-open";

        # Git 
        ga = "git add";
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
      };
    };
  };
}
