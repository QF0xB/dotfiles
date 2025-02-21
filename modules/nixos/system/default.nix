{
  lib,
  config,
  ...
}:

{
  imports = [
    ./boot
    ./gnupg.nix
    ./shells.nix
    ./environment.nix
    ./localization.nix
    ./ssh-server.nix
    ./packages.nix
    ./fonts.nix
    ./security
    ./gnupg.nix
    ./zfs.nix    
  ];

  config.qnix.system = with lib; {
    openssh = {
      enable = mkDefault true;
      password-auth = mkDefault true;
    };

    boot = {
      grub.enable = true;
      systemd-boot.enable = false; 
    };

    localization = {
      dual-qkeyboard = mkDefault true;
      console-xkb-bridge = mkDefault true;
      english-german-locales = mkDefault true;
    };

    packages = with lib; {
     git.install = mkDefault true;
     tree.install = mkDefault true;
     yubico.install = mkDefault false;
    };

    zfs = {
      encrypted = mkDefault true;
    };

    environment = {
      systemPackages.custom-shell.enable = mkDefault true;
    };
 
    security = {
      polkit.enable = mkDefault true;      
      u2f.enable = mkDefault true;
      yubico.enable = mkDefault true;
    };

    gnupg = {
      enable = mkDefault true;
    };
  };
}
