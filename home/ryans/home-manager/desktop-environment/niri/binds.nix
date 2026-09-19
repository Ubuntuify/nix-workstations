{
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
}
