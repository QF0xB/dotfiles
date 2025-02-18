{
  options, 
  lib,
  config,
  ... 
}:

let
  cfg = config.qnix;
in
{
  config = {
    qnix.persist.home = {
        directories = [
          ".ssh"
        ];
      };
  };
}
