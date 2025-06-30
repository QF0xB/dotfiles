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
      isVm ? false,
      isInstall ? false,
      isLaptop ? false,
      isNixOS ? true,
      extraConfig ? { },
    }:
    lib.nixosSystem {
      inherit pkgs;

      specialArgs = specialArgs // {
        inherit
          host
          isVm
          isInstall
          isLaptop
          isNixOS
          user
          ;
        dots = "/persist/home/${user}/projects/dotfiles";
      };

      modules = [
        ./${host} # host specific configuration
        ./${host}/hardware.nix # host specific hardware configuration
        ../overlays
        ../modules/nixos # Default NixOS config
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            # inherit (args) pkgs;
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = specialArgs // {
              inherit
                host
                isVm
                isInstall
                isLaptop
                isNixOS
                user
                ;
              dots = "/persist/home/${user}/projects/dotfiles";
            };

            users.${user} = {
              imports = [
                inputs.nix-index-database.hmModules.nix-index
                inputs.sops-nix.homeManagerModules.sops
                inputs.nvf.homeManagerModules.default
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
        inputs.nvf.nixosModules.default
        extraConfig
      ];
    };
in
{
  QPC = mkNixosConfiguration "QPC" { };
  QPC-install = mkNixosConfiguration "QPC" { isInstall = true; };
  QFrame13 = mkNixosConfiguration "QFrame13" { isLaptop = true; };
  QFrame13-install = mkNixosConfiguration "QFrame13" {
    isInstall = true;
    isLaptop = true;
  };
  vm = mkNixosConfiguration "vm" { isVm = true; };
}
