{
  ...
}:

{
  config = {
    home.file.".config/hypr/scripts/gamingmode.sh" = {
      text = ''
        #!/bin/sh

        TOGGLE=$HOME/.config/hypr/.desktoptoggle
        FILE=$HOME/.config/hypr/hyprland.conf

        if [ ! -e $TOGGLE ]; then
          touch $TOGGLE
          sed -i '/kb_layout = us #t/s/^/#/g' $FILE
          sed -i '/kb_layout = de/s/^#//g' $FILE
          sed -i '/kb_variant = koy/s/^#//g' $FILE 
        else
          rm $TOGGLE
          sed -i '/kb_layout = us #t/s/^#//g' $FILE 
          sed -i '/kb_layout = de/s/^/#/g' $FILE
          sed -i '/kb_variant = koy/s/^/#/g' $FILE
        fi
      '';
      executable = true;
    };
  };
}
