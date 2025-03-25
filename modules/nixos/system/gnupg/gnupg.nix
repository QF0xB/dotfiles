{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.qnix.system.gpg = {
    enable = lib.mkEnableOption "Enable system-wide GPG configuration";
  };

  config = lib.mkIf config.qnix.system.gpg.enable {
    # Generate /etc/gnupg/gpg.conf with your GPG settings.
    environment.etc."gnupg/gpg.conf".source = lib.mkForce (
      pkgs.writeText "gpg.conf" ''
        personal-cipher-preferences = AES256 AES192 AES
        personal-digest-preferences = SHA512 SHA384 SHA256
        personal-compress-preferences = ZLIB BZIP2 ZIP Uncompressed
        default-preference-list = SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
        cert-digest-algo = SHA512
        s2k-digest-algo = SHA512
        s2k-cipher-algo = AES256
        charset = utf-8
        fixed-list-mode
        no-comments
        no-emit-version
        keyid-format 0xlong
        list-options show-uid-validity
        verify-options show-uid-validity
        with-fingerprint
        require-cross-certification
        no-symkey-cache
        use-agent
        throw-keyids
      ''
    );
    environment.etc."gnupg/gpg.conf".mode = "0600";

    # Generate /etc/gnupg/scdaemon.conf to disable direct CCID access.
    environment.etc."gnupg/scdaemon.conf".source = pkgs.writeText "scdaemon.conf" ''
      reader-port Yubico Yubi
      disable-ccid
    '';
    environment.etc."gnupg/scdaemon.conf".mode = "0600";

    # Generate /etc/gnupg/gpg-agent.conf with agent settings.
    # (Note: gpg-agent will look in ~/.gnupg/gpg-agent.conf first, but if absent it will use /etc/gnupg/gpg-agent.conf.)
    environment.etc."gnupg/gpg-agent.conf".source = lib.mkForce (
      pkgs.writeText "gpg-agent.conf" ''
        default-cache-ttl 60
        max-cache-ttl 120
        pinentry-program ${pkgs.pinentry-gnome3}/bin/pinentry
        ttyname $GPG_TTY
      ''
    );
    environment.etc."gnupg/gpg-agent.conf".mode = "0600";

    programs = {

      gnupg = {
        agent = {
          enable = true;
          enableSSHSupport = true;
          pinentryPackage = pkgs.pinentry-gnome3;
        };
      };

      ssh.startAgent = false;
    };

    qnix.persist.root.directories = [
      "/etc/gnupg"
    ];
  };
}
