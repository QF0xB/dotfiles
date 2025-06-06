{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.system.environment;
  pkgs-cfg = config.qnix.system.packages;
in
{
  options.qnix.system.environment = with lib; {
    systemPackages.custom-shell.enable = mkEnableOption "custom-shell packages" // {
      default = true;
    };
  };

  config = with lib; {
    environment = {
      systemPackages =
        with pkgs;
        concatLists [
          (lists.optionals pkgs-cfg.git.install [ git ])
          (lists.optionals pkgs-cfg.tree.install [ tree ])
          [ pam_u2f ]
          (lists.optionals pkgs-cfg.yubico.install [
            pcsclite
            yubikey-personalization
          ])
          (lists.optionals (pkgs-cfg.yubico.install && !config.hm.qnix.headless) [ yubioath-flutter ])
          (lists.optionals pkgs-cfg.helix.install [ helix ])
          (lists.optionals pkgs-cfg.kitty.install [ kitty ])
          # add custom-shell packages
          (lists.optionals cfg.systemPackages.custom-shell.enable (
            lib.attrValues config.hm.qnix.applications.shells.packages
          ))
          [
            nvfetcher
            nfs-utils
          ]

        ];
    };

    # create symlinks
    systemd.user.tmpfiles.rules =
      let
        normalizeHome = p: if (hasPrefix "/home" p) then p else "${config.home.homeDirectory}/${p}";
      in
      mapAttrsToList (
        dest: src: "L+ ${normalizeHome dest} - - - - ${src}"
      ) config.hm.qnix.applications.shells.symlinks;

    environment.shellInit = ''
      # GPG 
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';

    programs.bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };
}
