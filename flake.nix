{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nur,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    host_name = "acer-nixos";
    user_name = "andrei_hamor";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable{
            inherit system;
            config.allowUnfree = true;
          };
        })
        nur.overlays.default
      ];
    }; 

  in {
    nixosConfigurations = {
      "${host_name}" = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        inherit system;
        modules = [
          ./nixos/configuration.nix
        ];
        specialArgs = {
          inherit inputs;
          inherit host_name;
          inherit user_name;

        };
      };
    };

 homeConfigurations = {
      "${user_name}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit system;
          inherit user_name;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };

  };
}
