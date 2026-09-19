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
      hardware.opentabletdriver.enable = true; # enable drawing tablet support
      home-manager.sharedModules = [
        # Krita is broken on Darwin systems, so we should only add it as a package on Linux.
        {
          home.packages =
            [
              pkgs.krita
            ]
            ++ (lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
              pkgs.davinci-resolve
            ]);
        }
      ];
    })
    (outputs.lib.unsafeIf isDarwin {
      homebrew = {
        casks = [
          # Use `homebrew` to install apps on Darwin systems, especially since most are marked broken.
          "krita"

          # OpenTabletDriver is not available on MacOS; use the wacom-tablet package instead (this
          # won't work if you don't have a wacom tablet)
          "wacom-tablet"
        ];

        masApps = {
          # These are Mac Store applications, defined with an ID.
          "DaVinci Resolve" = 571213070;
        };
      };
    })
  ]
