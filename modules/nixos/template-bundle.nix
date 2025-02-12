{
  lib,
  ...
}:

{
  imports = [
    ./systemd-boot.nix
    ./gnupg.nix
    ./localization.nix
    ./ssh-server.nix    
  ];

  config = with lib; {
    qnix.system.openssh = {
      enable = mkDefault true;
      password-auth = mkDefault true;
    };
  };
}
