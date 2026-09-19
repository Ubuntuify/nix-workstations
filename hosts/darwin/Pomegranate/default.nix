{
  outputs,
  modules,
  ...
}: {
  imports =
    [
      ./system-specific/dock.nix
      modules.profiles.content-creation
    ]
    ++ (outputs.lib.__internal__.getUserCfgs ["ryans"] ../../../home "darwin");

  system.defaults = {
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleShowScrollBars = "Always";
    };
    WindowManager = {
      EnableTilingByEdgeDrag = false; # should be taken over by cask 'Rectangle'
    };
  };

  programs.fish.enable = true;

  system.stateVersion = 6;
}
