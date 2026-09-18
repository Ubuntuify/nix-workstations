{
  description = "Ryan's Nix configuration flake";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  inputs = {
    self.submodules = true; # enable submodules support

    # Main system components (i.e. NixOS, nix-darwin, etc.)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs"; # These stop nix from downloading multiple instances of nixpkgs

    # Secrets manager
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # User components (such as for: setting up home directories, and homebrew)
    home-manager = {
      url = "github:nix-community/home-manager"; # sets up home applications and their settings
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf"; # setups nvim with appropriate settings for development
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew"; # homebrew for nix-darwin
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Support modules (modules that connect to main system components to add patches for NixOS to work)
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main"; # for windows subsystem for linux (weird name), can build tarballs
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon/main"; # asahi linux, this comes with a module defined for ease
      inputs.nixpkgs.follows = "nixpkgs"; # of use.
    };

    # Alternate repositories (such as repositories for Firefox addons, etc.)
    nur = {
      url = "github:nix-community/NUR"; # used this primarily for Firefox addons, but can be used for other things
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake components (components used by the flake for management, etc.)
    haumae = {
      url = "github:nix-community/haumea/v0.2.2"; # might want to move away from this, but auto-imports modules like
      inputs.nixpkgs.follows = "nixpkgs"; # how you would do it in other programming languages
    };
  };

  outputs = inputs @ {self, ...}: let
    inherit (self) outputs;
    inherit (inputs.nixpkgs) lib;
  in {
    # Uses `haumae` to recusively import all overlays in ./overlays/
    overlays = inputs.haumae.lib.load {src = ./overlays;};

    # Internal library for within the flake. Can be accessed through `outputs.lib`
    lib = import ./lib {inherit self inputs outputs;};

    nixosConfigurations = let
      mkNixosSystems = systemPath: let
        systems = builtins.readDir (builtins.toPath systemPath);
      in
        builtins.mapAttrs (host: type:
          if (type == "directory")
          then let
            systemMetadata = fromTOML (builtins.readFile (systemPath + "/${host}/system.toml"));
            inherit (systemMetadata) system;
          in
            outputs.lib.sysconfig.mkNixos {
              system = system.architecture or "x86_64-linux";
              hostname = system.hostname or host;
              sysadmin = lib.mkIf (builtins.hasAttr "users" systemMetadata) systemMetadata.users.sysadmin;
            }
          else null)
        systems;
    in
      mkNixosSystems ./hosts/nixos;

    darwinConfigurations = let
      mkDarwinSystems = systemPath: let
        systems = builtins.readDir (builtins.toPath systemPath);
      in
        builtins.mapAttrs (host: type:
          if (type == "directory")
          then let
            systemMetadata = fromTOML (builtins.readFile (systemPath + "/${host}/system.toml"));
          in
            outputs.lib.sysconfig.mkDarwin {
              hostname = systemMetadata.system.hostname or host;
              sysadmin = systemMetadata.users.sysadmin or "ryans";
              system = systemMetadata.system.architecture or "aarch64-darwin"; # set the default to Apple Silicon, because who uses an actual x86_64 Mac anyways (unless it's a Hackintosh or something)
            }
          else null)
        systems;
    in
      mkDarwinSystems ./hosts/darwin;

    formatter = outputs.lib.forEachSupportedSystem ({pkgs}: pkgs.alejandra);
  };
}
