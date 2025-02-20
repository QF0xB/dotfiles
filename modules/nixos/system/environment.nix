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
    systemPackages.custom-shell.enable = mkEnableOption "custom-shell packages";
  };

  config = with lib; {
    environment = {
      systemPackages = with pkgs; concatLists [ 
        (lists.optionals pkgs-cfg.git.install [ git ])
        (lists.optionals pkgs-cfg.tree.install [ tree ])
        (lists.optionals config.qnix.system.security.u2f.enable [ pam_u2f ])
        (lists.optionals pkgs-cfg.yubico.install [ yubioath-flutter ])
        # add custom-shell packages
        (lists.optionals cfg.systemPackages.custom-shell.enable (lib.attrValues config.qnix.system.shell.packages))
      ];
    };

    # create symlinks
    systemd.user.tmpfiles.rules =
      let
        normalizeHome = p: if (hasPrefix "/home" p) then p else "${config.home.homeDirectory}/${p}";
      in
      mapAttrsToList (dest: src: "L+ ${normalizeHome dest} - - - - ${src}") config.qnix.system.shell.symlinks;
  };
}
