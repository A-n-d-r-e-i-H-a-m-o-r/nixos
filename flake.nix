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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
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
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
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
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
        nur.overlays.default
      ];
    };
    fonts = import ./fonts {inherit pkgs;};
  in {
    nixosConfigurations = {
      "${host_name}" = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        inherit system;
        modules = [
          ./system/configuration.nix
        ];
        specialArgs = {
          inherit inputs;
          inherit host_name;
          inherit user_name;
          inherit fonts;
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
