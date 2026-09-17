{
  pkgs,
  options,
  outputs,
  lib,
  ...
}: let
  isLinux = builtins.hasAttr "hardware" options; # 'hardware' only exists on NixOS systems;
  isDarwin = builtins.hasAttr "homebrew" options; # 'homebrew' configs only exist on nix-darwin.
in
  lib.mkMerge [
    (outputs.lib.unsafeIf isLinux {
      home-manager.sharedModules = [
        # Krita is broken on Darwin systems, so we should only add it as a package on Linux.
        {home.packages = [pkgs.krita];}
      ];

      hardware.opentabletdriver.enable = true;
    })
    (outputs.lib.unsafeIf isDarwin {
      homebrew.casks = [
        # Use `homebrew` to install Krita. Krita is designated broken on `darwin` systems.
        "krita"
        # OpenTabletDriver is not available on MacOS; use the wacom-tablet package instead (this
        # won't work if you don't have a wacom tablet)
        "wacom-tablet"
      ];
    })
  ]
