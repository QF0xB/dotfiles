{
  lib,
  ...
}:

{
  imports = [
    ./backup
    ./bluetooth
    ./boot
    ./environment
    ./gnupg
    ./localisation
    ./networking/networking.nix
    ./nvidia
    ./packages.nix
    ./powersavings
    ./screen
    ./security
    ./ssh-server
    ./zfs
  ];

  config.qnix.system = with lib; {
    openssh = {
      enable = mkDefault true;
      password-auth = mkDefault true;
    };

    boot = {
      grub.enable = mkDefault true;
      systemd-boot.enable = mkDefault false;
    };

    localization = {
      dual-qkeyboard = mkDefault true;
      console-xkb-bridge = mkDefault true;
      english-german-locales = mkDefault true;
    };

    packages = with lib; {
      git.install = mkDefault true;
      tree.install = mkDefault true;
      yubico.install = mkDefault true;
      helix.install = mkDefault false;
      kitty.install = mkDefault true;
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

    gpg = {
      enable = mkDefault true;
    };

    stylix = {
      enable = mkDefault true;
    };
  };
}
