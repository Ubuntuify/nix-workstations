{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.niri = {
    enable = builtins.all (s: s) [
      pkgs.stdenv.hostPlatform.isLinux
      config.perpensity.roles.graphics
      (config.perpensity.platform.linux.windowManager == "niri")
    ];

    systemd.enable = true;

    settings = {
      spawn-at-startup = ["dms" "run"]; # run Dank Material Shell at startup

      # Tiling manager options (such as layout options)
      layout = {
        gaps = 16; # gaps around windows in logical pixels

        center-focused-column = "on-overflow";

        preset-column-widths._children = [
          {proportion = 0.33333;}
          {proportion = 0.5;}
          {proportion = 0.66667;}
        ];

        default-column-width = {proportion = 0.5;};

        border = {off = {};};

        shadow = {
          on = {}; # turn on drop shadows for windows

          softness = 30;
          spread = 10;
          offset._props = {
            x = 0;
            y = 5;
          };
          color = "#0007";
        };

        struts = {
          left = 32;
          right = 64;
        };
      };

      hotkey-overlay = {skip-at-startup = {};}; # skip hotkey overlay (for first startup)
      prefer-no-csd = {}; # remove client-side decorations

      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"; # screenshot name

      animations = let
        default-sprint = {
          spring._props = {
            damping-ratio = 1.0;
            stiffness = 500;
            epsilon = 0.00001;
          };
        };
      in {
        slowdown = 1.5; # slow-down all animations by what factor

        overview-open-close = default-sprint;
        horizontal-view-movement = default-sprint;
        workspace-switch = default-sprint;
        window-open = default-sprint;
        window-close = default-sprint;
        window-movement = default-sprint;
        window-resize = default-sprint;
        config-notification-open-close = default-sprint;
        exit-confirmation-open-close = default-sprint;
      };

      _children =
        [
          {
            # Internal monitor (most laptops use eDP-1 to point out an internal monitor)
            output = {
              _args = ["eDP-1"];
              scale = 1.5; # assume laptop display is HiDPI
              transform = "normal";
            };
          }
          {
            input = {
              touchpad = {
                natural-scroll = {};
                accel-speed = 0.325;
                accel-profile = "flat";
              };

              focus-follows-mouse._props = {max-scroll-amount = "80%";}; # overscroll autofocus
            };
          }
        ]
        ++ (import ./window-rules.nix);

      binds = import ./binds.nix; # move binds to its own separate file.
    };
  };
}
