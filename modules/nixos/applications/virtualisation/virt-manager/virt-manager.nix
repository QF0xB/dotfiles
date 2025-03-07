{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.qnix.applications.virtualisation.virt-manager;
  inherit (lib) mkIf;
in
{
  options.qnix.applications.virtualisation.virt-manager = with lib; {
    enable = mkEnableOption "VM support" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    users.users.${user}.extraGroups = [ "libvirtd" ];

    qnix.persist = {
      root = {
        cache.directories = [ "/var/lib/libvirtd" ];
      };
    };
  };
}
