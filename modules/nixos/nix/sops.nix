{
  config, 
  lib,
  pkgs,
  user, 
  dots,
  ...
}:

{
  options.qnix = with lib; {
    nix.sops.enable = mkEnableOption "sops";
  };

  config = lib.mkIf config.qnix.nix.sops.enable {
    sops = {
      defaultSopsFile = ../../../secrets/example.yaml;
      age.generateKey = true;
      age.sshKeyPaths = ["/home/${user}/.config/sops/age/ed-key"];
      secrets.my-config = {
        format = "yaml";
        key = "";
      };
    };
  };
}
