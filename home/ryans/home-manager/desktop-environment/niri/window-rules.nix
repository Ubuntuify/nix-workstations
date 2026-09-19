[
  # Universal window rule to apply to all windows. Currently used to apply corner radius to all
  # windows.
  {
    window-rule._children = [
      # Corner radius
      {geometry-corner-radius = 20;}
      {clip-to-geometry = true;}
    ];
  }

  # Blur unfocused windows with a blur effect, makes things look cooler.
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

  # Make all Picture-in-Picture Firefox windows floating by default, rather than tiling.
  # This makes sure that PIP Firefox windows do not tile similarly, and rather float.
  {
    window-rule._children = [
      {
        match._props = {
          app-id = "firefox";
          title = "^Picture-in-Picture$";
        };
        open-floating = true;
      }
    ];
  }

  # Manually blur Alacritty (terminal emulator) with a window rule. Alacritty already has
  # a setting which sets its opacity. So, only the background-effect is needed.
  {
    window-rule._children = [
      {
        match._props = {
          app-id = "^Alacritty$";
        };
        background-effect.blur = true;
      }
    ];
  }
]
