{
  options, 
  lib,
  config,
  ... 
}:

let
  cfg = config.qnix.;
in
{
  options.qnix = with lib; {
     = mkEnableOption "";
  };

  config = {
    
  };
}
