{
  outputs,
  config,
  lib,
  ...
}: let
in
  lib.mkMerge [
    {
      users.users.ryans = {
        isNormalUser = true;
        hashedPasswordFile = lib.mkIf (!config.users.mutableUsers) config.sops.secrets.users."passwords/ryans".path;
        extraGroups = [
          "wheel" # administrator group
          "networkmanager" # able to edit and modify network connections
          "pipewire" # requirement of system-wide pipewire
        ];

        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../../secrets/keys/ryans/id_ed25519.pub) # openssh is available to any machine that is
          # part of this flake/or uses the secrets repository.
        ];
      };

      home-manager.users.ryans = outputs.lib.home-manager.mkHomeEntry {
        user = "ryans";
        options = {linux.windowManager = "niri";}; # TODO: Fix later
      };
    }

    # sops-nix security plugin is only conditionally made when the "sops" nixosModule is active.
    # -
    # Othwerise, the configuration will simply be ignored (and most likely result in an evaluation error)
    (lib.mkIf (builtins.hasAttr "sops" config) {
      sops.secrets = {
        "passwords/ryans".neededForUsers = true;
      };
    })
  ]
