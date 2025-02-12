{
  lib,
  config,
  ...
}:

{
  imports = [
    ./systemd-boot.nix
    ./gnupg.nix
    ./localization.nix
    ./ssh-server.nix
    ./packages.nix    
  ];

  config.qnix.system = with lib; {
    openssh = {
      enable = mkDefault true;
      password-auth = mkDefault true;
    };

    boot = {
      systemd-boot.enable = true;
    };

    localization = {
      dual-qkeyboard = mkDefault true;
      console-xkb-bridge = mkDefault true;
      english-german-locales = mkDefault true;
    };

    packages = with lib; {
     git.install = mkDefault true;
     tree.install = mkDefault true;
    };
  };
}
