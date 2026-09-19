{lib, ...} @ args: {
  options.perpensity = {
    # Machine-specific options, such as mitigating for low RAM or whether graphical applications should be enabled
    # in the config
    roles = {
      graphics = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to enable graphical applications, such as Firefox or Alacritty.";
        default = args.nixosConfig.hardware.graphics.enable or (builtins.hasAttr "darwinConfig" args); # this is making an assumption that
        # all nix-darwin setups are for development only and not for server use.
      };

      ramConservation = lib.mkEnableOption "some low RAM mitigation features, such as auto-tab-discard, etc.";
    };

    platform = {
      # Linux-specific options, these have no effect when not on a Linux machine.
      linux = {
        windowManager = lib.mkOption {
          type = lib.types.enum ["sway" "niri" null];
          description = "Which window manager (and respective config) to use.";
          default = "sway";
        };
      };
    };
  };
}
