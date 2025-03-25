{
  description = "QNixOS config v1";

  inputs = {
    # Unstable NixOS Packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Stable NixOS Packages.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master"; # DEV

    qnix-pkgs.url = "github:stormfox2/qnix-pkgs";

    # Nix-index for unstable
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware Optimisation
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    # Impermenance (non-persistent root (/))
    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # NeoVim
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Disko disk utility
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #    home-manager-stable = {
    #      url = "github:nix-community/home-manager/release-24.11";
    #      inputs.nixpkgs.follows = "nixpkgs-stable";
    #    };

    # Secret manager SOPS
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Global styling
    stylix = {
      url = "github:danth/stylix";
    };

  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-master,
      self,
      ...
    }:
    let
      system = "x86_64-linux";
      create-overlay =
        version: final: rev:
        let
          nixpkgsForVersion = builtins.getAttr ("nixpkgs-" + version) inputs;
        in
        {
          ${version} = import nixpkgsForVersion {
            inherit system;
            config.allowUnfree = true;
            config.nvidia.acceptLicense = true;
          };
        };

      overlay-stable = create-overlay "stable";
      overlay-master = create-overlay "master";

      pkgs = import inputs.nixpkgs {
        hostplatform = system;
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "electron-32.3.3"
          ];
        };
        overlays = [
          overlay-stable
          overlay-master
          inputs.qnix-pkgs.overlays.default
        ];
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      lib = import ./lib.nix {
        inherit (nixpkgs) lib;
        inherit pkgs;
        inherit (inputs) home-manager;
      };
      createCommonArgs = system: {
        inherit
          self
          inputs
          nixpkgs
          nixpkgs-stable
          lib
          pkgs
          pkgs-stable
          system
          ;
        specialArgs = {
          inherit self inputs;
        };
      };
      commonArgs = createCommonArgs system;
    in
    {
      nixosConfigurations = import ./hosts/nixos-hosts.nix commonArgs;
    };
}
