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
    lib.nixosSystem {
      inherit pkgs;

      specialArgs = specialArgs // {
        inherit host user;
        isNixOS = true;
        isLaptop = host == "QFrame13";
        isVm = lib.strings.hasPrefix "vm" host || lib.strings.hasPrefix "backup" host;
        dots = "/persist/home/${user}/projects/dotfiles";
      };

      modules = [
        ./${host} # host specific configuration
        ./${host}/hardware.nix # host specific hardware configuration
        ../modules/nixos # Default NixOS config
        inputs.home-manager.nixosModules.home-manager
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
                inputs.nix-index-database.hmModules.nix-index
                inputs.sops-nix.homeManagerModules.sops
                ./${host}/home.nix # host specific home-manager configuration
                ../modules/home-manager # default home-manager configuration
              ];
            };
          };
        }
        # alias for home-manager
        (lib.mkAliasOptionModule
          [ "hm" ]
          [
            "home-manager"
            "users"
            user
          ]
        )
        inputs.impermanence.nixosModules.impermanence # single-use root (/)
        inputs.sops-nix.nixosModules.sops # secret management
        inputs.stylix.nixosModules.stylix
        inputs.qnix-pkgs.nixosModules.default
        #TURNED OFF REPLACED BY SCRIPT        inputs.disko.nixosModules.disko #disk management
      ];
    };
in
{
  QPC = mkNixosConfiguration "QPC" { };
  QFrame13 = mkNixosConfiguration "QFrame13" { };
  vm = mkNixosConfiguration "vm" { };
}
