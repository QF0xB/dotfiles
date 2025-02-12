{
  inputs,
  lib,
  specialArgs,
  user ? "lcqbraendli",
  ...
}@args:
let
  # provide an optional { pkgs } 2nd argument to override the pkgs
  mkNixosConfiguration =
    host:
    {
      pkgs ? args.pkgs,
    }:
    {
      hm-pkgs ? inputs.home-manager,
    }:
    lib.nixosSystem {
      inherit pkgs;

      specialArgs = specialArgs // {
        inherit host user;
        isNixOS = true;
        isLaptop = host == "qframe13";
        isVm = lib.strings.hasPrefix "vm" host;
        dots = "/persist/home/${user}/projects/dotfiles";
      };

      modules = [
        ./${host} # host specific configuration
        ./${host}/hardware.nix # host specific hardware configuration
        ../modules/nixos # Default NixOS config
        hm-pkgs.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = specialArgs // {
              inherit host user;
              isNixOS = true;
              isLaptop = host == "QFrame13";
              isVm = lib.strings.hasPrefix "vm" host;
              dots = "/persist/home/${user}/projects/dotfiles";
            };

            users.${user} = {
              imports = [
                ./${host}/home.nix # host specific home-manager configuration
                ../modules/home-manager # default home-manager configuration
              ];
            };
          };
        }
        # alias for home-manager
        (lib.mkAliasOptionModule [ "hm" ] [
          "home-manager"
          "users"
          user
        ])
        inputs.impermanence.nixosModules.impermanence #single-use root (/)
        inputs.sops-nix.nixosModules.sops #secret management
        inputs.disko.nixosModules.disko #disk management
      ];
    };
in
{
  qpc = mkNixosConfiguration "QPC" {} { };
  qframe13 = mkNixosConfiguration "QFrame13" { };
}
