{
  outputs,
  pkgs,
  modules,
  ...
}: let
  inherit (outputs) overlays;
in {
  imports = [
    ./generated/hardware-configuration.nix
    ./system-specific/bootloader.nix
    ./system-specific/swap.nix
    modules.hardware-specific.asahi
    modules.security.sops
    modules.features.audio
    modules.features.fonts
    modules.features.networking
    modules.features.printing
    modules.features.bluetooth
    modules.window-manager
    modules.display-manager.dms
    modules.security.sops
    modules.drawing
    (outputs.lib.users.getNixUserModule "ryans")
  ];

  # Options required for Asahi (apple-silicon)'s hardware module, such as providing the firmware hash
  # for pure flakes, and other options like touch bar support.
  custom.asahi = {
    firmwareHash = "sha256-5p9g6q8YdbTtc5YrjB4MInxxIiQNMbUoihLzyhSa7AQ=";
    touchBarSupport = false; # broken
  };

  nixpkgs.overlays = [
    overlays.lix
  ];

  services.xserver.enable = true;

  security.polkit.enable = true;

  services.gvfs.enable = true;

  programs.dconf.enable = true;

  environment.extraInit = ''
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  '';

  programs.niri.enable = true;

  programs.nix-ld.enable = true;

  services.upower.enable = true;

  system.stateVersion = "25.11";
}
