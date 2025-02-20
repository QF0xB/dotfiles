{
  lib,
  ...
}:

{
  imports = [
    ./polkit.nix
    ./u2f.nix
  ];

#  config.qnix.system.security = with lib; {
#    polkit.enable = mkDefault true;
#    yubico.enable = mkDefault true;
#    u2f.enable = mkDefault true;    
#  };
}
