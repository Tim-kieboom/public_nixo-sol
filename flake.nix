{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # terminal ide
    terminal_code.url = "github:Tim-kieboom/TerminalCode";

    # statusbar/wallpaper
    sol-shell.url = "github:Tim-kieboom/sol-shell";

    # ai
    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, claude-desktop, ... } @ inputs:
    let
      vars = import ./vars.nix;

      # Build one machine from hosts/<hostName>/default.nix.
      # To add a computer: copy hosts/nixos, run `nixos-generate-config` there,
      # and add a line to `nixosConfigurations` below.
      mkHost = hostName: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit self inputs vars hostName; };
        modules = [
          ./modules/common.nix
          ./hosts/${hostName}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;     # reuse system nixpkgs (keeps allowUnfree)
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs vars hostName; };
            home-manager.backupFileExtension = "backup";
            home-manager.users.${vars.username} = {
              imports = [ ./home ];
            };
          }
        ];
      };
    in {
      packages.x86_64-linux.claude-desktop =
        claude-desktop.packages.x86_64-linux.claude-desktop;

      nixosConfigurations = {
        nixos = mkHost "nixos";
      };
    };
}
