{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      # "aarch64-linux"
      # "i686-linux"
      "x86_64-linux"
      # "aarch64-darwin"
      # "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    pkgsFor = system: import nixpkgs {
      system = system;
      config.allowUnfree = true;
    };
    unstablePkgsFor = system: import nixpkgs-unstable {
      system = system;
      config.allowUnfree = true;
    };
  in {
    formatter = forAllSystems (system: (pkgsFor system).alejandra);
    nixosConfigurations = {
      sparta = forAllSystems (system:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = { inherit inputs outputs; };
        modules = [
            ./hosts/sparta/configuration.nix
            stylix.nixosModules.stylix
        ];
        });
      ark = forAllSystems (system:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/ark/configuration.nix
            stylix.nixosModules.stylix
          ];
        });
    };
    homeConfigurations = {
      "tudor" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor "x86_64-linux";
        extraSpecialArgs = {
          inherit inputs outputs;
          unstablePkgs = unstablePkgsFor "x86_64-linux";
  };
        modules = [
          ./home-manager/home.nix
          stylix.homeManagerModules.stylix
        ];
      };
    };
  };
}