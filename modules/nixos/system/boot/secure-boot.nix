{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.hm.qnix.system.boot.secure-boot;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sbctl
    ];

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    # system.activationScripts.secureBootSign.text = ''
    # echo "Signing new EFI binaries with sbctl..."
    # ${pkgs.sbctl}/bin/sbctl sign-all
    # '';

    qnix.persist.root.directories = [
      "/var/lib/sbctl"
    ];

  };
}
