{
  lib,
  config,
  user,
  pkgs,
  ...
}:

let
  cfg = config.qnix.users.default-user;
  sopsConfig = lib.mkIf config.hm.qnix.nix.sops.enable (
    let
      inherit (config.sops) secrets;
    in
    {
      # See: https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
      sops.secrets = {
        rp.neededForUsers = true;
        up.neededForUsers = true;
      };

      # Create a password for root and for the user.
      # Run: mkpasswd -m sha-512 'PASSWORD' and put the result in secrets.json
      users.users = {
        root.hashedPasswordFile = lib.mkForce secrets.rp.path;
        "${user}".hashedPasswordFile = lib.mkForce secrets.up.path;
      };
    }
  );
in
with lib;
{
  options = {
    warnings = lib.mkOption {
      apply = lib.filter (
        w: !(lib.strings.hasInfix "If multiple of these password options are set at the same time" w)
      );
    };

    qnix.users.default-user.enable = mkEnableOption "default user.";

    qnix.users.default-user.shell = mkOption {
      type = types.package;
      default = pkgs.fish;
      description = "Shell to use.";
    };
  };

  config = mkMerge [
    {
      users = {
        mutableUsers = false;

        groups = {

        };

        users = {
          root = {
            initialPassword = "password";
            hashedPasswordFile = "/persist/etc/shadow/root";
          };

          ${user} = mkIf cfg.enable {
            isNormalUser = true;
            home = "/home/${user}";
            description = if user == "lcqbraendli" then "Quirin Brändli" else user;
            extraGroups = [
              "wheel"
              "networkmanager"
            ];
            #            shell = cfg.shell;
            ignoreShellProgramCheck = true;
            initialPassword = "password";
            hashedPasswordFile = "/persist/etc/shadow/${user}";
            openssh.authorizedKeys.keys = [
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDk4DIfOYj5u7Gy01r5eVUuJzaniD8N1pJqOmxtgWRaiMlS+v5Za/Xu2vRpMNoO2lb8nr/FNev4p1wuzNEQjJoEcLTM0JMbUs+4AakUbdOq2P9rAH4A7rNP24fcVtAjSGp/g9krWA3J/WxttNJ0HGfNuSCX871gy6K36KF7l3Jpnfz6h+RwwNsvxTiP/a8S2WFuzr3Wt49px7k4usyQBQoBsOR9EkeqvERsWkBFOltDlqi6GbLTFmaV7B1LQPlAyBOnzvJ0Jp/IM4eyzR6Bc6pVoWxUH619GBifL85qCTGgPDMVnljxRDd0gt8bIueF41lEM/1arJQNH8XdUIF/mX7u7hNYw7MVPmkkwbLy2NUjh0/5RzU8hdE3J9aLRT/EwjZF/0ratIRvjNvGohm0U84jjraCmfZqezgaL3E9DCgXabgDAex9lVlDG/N6b07J0MJ8w2enbOI344iHv2ZpcODoi2ZB674mBDNsarmIUsi2vacCN8/pogirNFDNrU5jEF2lVHrJjNka0sTPlhrk1EoiT1dOcd9X3+STM7SEcY5R8YARCxBD3q3RG1u6f1akFN+QyvEUiV+hVtfrKnTwl2ldZ7Dmlbj7ghhudQQrRNGQ5PvjhNbTLtk+l4sfRbDiiVA0BU9AZiqZq0PeVXErJft2TTPP8UKGN35qGly4YHzfhw== cardno:25_390_975"
            ];
          };
        };
      };
    }
    sopsConfig
  ];
}
