{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.niri = {
    enable = builtins.all (s: s) [
      pkgs.stdenv.hostPlatform.isLinux
      config.custom.system.graphics
      (config.custom.linux.windowManager == "niri")
    ];

    systemd = {
      enable = true;
    };

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
          spring = {
            _props = {
              damping-ratio = 1.0;
              stiffness = 500;
              epsilon = 0.00001;
            };
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

      _children = [
        {
          output = {
            # Internal monitor (most laptops use eDP-1 to point out an internal monitor)
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
        {
          window-rule._children = [
            # Make all Picture-in-Picture Firefox windows floating by default, rather than tiling
            {
              match = {
                _props = {
                  app-id = "firefox";
                  title = "^Picture-in-Picture$";
                };
              };
              open-floating = true;
            }
          ];
        }
        {
          window-rule._children = [
            {
              match = {
                _props = {
                };
              };
            }
          ];
        }
        {
          window-rule._children = [
            # Blur Alacritty with new blur effect.
            {
              match = {
                _props = {
                  app-id = "^Alacritty$";
                };
              };
              background-effect.blur = true;
            }
          ];
        }
        {
          window-rule._children = [
            # Corner radius
            {geometry-corner-radius = 24;}
            {clip-to-geometry = true;}
          ];
        }
        {
          window-rule._children = [
            {
              match._props = {
                is-active = false;
              };
              opacity = 0.8;
              background-effect.blur = true;
            }
          ];
        }
      ];

      binds = {
        # Manipulate windows, either tiling or floating...
        "Mod+Comma".consume-window-into-column = {};
        "Mod+Period".expel-window-from-column = {};

        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";

        "Mod+T".toggle-window-floating = {};
        "Alt+T".switch-focus-between-floating-and-tiling = {};

        "Mod+Shift+E".quit = {};

        "Mod+F".maximize-column = {};
        "F11".maximize-window-to-edges = {};

        "F12".screenshot = {}; # screenshot commands
        "Ctrl+F12".screenshot-screen = {};
        "Alt+F12".screenshot-window = {};

        "Mod+Q".close-window = {}; # close program (MacOS-style keybind, more friendly)
        "Alt+F4".close-window = {}; # exit program (Windows style keybind)

        # Move windows around (subcategory)
        "Mod+Shift+1".move-column-to-workspace = 1;
        "Mod+Shift+2".move-column-to-workspace = 2;
        "Mod+Shift+3".move-column-to-workspace = 3;
        "Mod+Shift+4".move-column-to-workspace = 4;
        "Mod+Shift+5".move-column-to-workspace = 5;
        "Mod+Shift+6".move-column-to-workspace = 6;
        "Mod+Shift+7".move-column-to-workspace = 7;
        "Mod+Shift+8".move-column-to-workspace = 8;
        "Mod+Shift+9".move-column-to-workspace = 9;
        "Mod+Shift+0".move-column-to-workspace = 10;

        # Change workspaces
        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;
        "Mod+6".focus-workspace = 6;
        "Mod+7".focus-workspace = 7;
        "Mod+8".focus-workspace = 8;
        "Mod+9".focus-workspace = 9;
        "Mod+0".focus-workspace = 10;

        # Screenshot commands using niri, either select, whole screens, or windows.
        "F12".screenshot = {};
        "Ctrl+F12".screenshot-screen = {};
        "Alt+F12".screenshot-window = {};

        "Mod+Q".close-window = {}; # close program (MacOS-style keybind, more friendly)
        "Alt+F4".close-window = {}; # exit program (Windows style keybind)

        # Application
        "Mod+Return".spawn = "alacritty"; # spawn a terminal
        "Mod+Space".spawn = ["dms" "ipc" "spotlight" "toggle"]; # spawn spotlight-like launcher (similar to fuzzel, etc.)
        "Mod+B".spawn = "firefox"; # spawn browser

        # Media keys - mostly function keys in principle (F13-F24)
        "XF86AudioRaiseVolume" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "audio" "decrement" "2.5"];
        };
        "XF86AudioLowerVolume" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "audio" "increment" "2.5"];
        };
        "XF86AudioMute" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "audio" "mute"];
        };
        "XF86AudioMicMute" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "audio" "micmute"];
        };
        "XF86AudioPlay" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "mpris" "playPause"];
        };
        "XF86AudioStop" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "mpris" "stop"];
        };
        "XF86AudioPrev" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "mpris" "previous"];
        };
        "XF86AudioNext" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "mpris" "next"];
        };
        "XF86MonBrightnessUp" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "brightness"];
        };
        "XF86MonBrightnessDown" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "brightness"];
        };
      };
    };
  };
}
