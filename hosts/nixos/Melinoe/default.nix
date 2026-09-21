{
  outputs,
  pkgs,
  modules,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    modules.hardware-specific.asahi
    modules.security.sops
    modules.features.audio
    modules.features.fonts
    modules.features.networking
    modules.features.printing
    modules.features.bluetooth
    modules.features.window-manager
    modules.features.plymouth
    modules.display-manager.mdgreet-greetd
    modules.security.sops
    modules.profiles.content-creation

    (outputs.lib.users.getNixUserModule "ryans")
  ];

  # Options that interact with the hardware-specific asahi module.
  perpensity.asahi = {
    firmwareHash = "sha256-5p9g6q8YdbTtc5YrjB4MInxxIiQNMbUoihLzyhSa7AQ=";
    touchBarSupport = true;
  };

  # Bootloader options
  boot = {
    supportedFilesystems = ["btrfs"];
    loader.limine = {
      enable = true;
      efiSupport = true;
      maxGenerations = 5;
    };
  };

  # Set "zswap" (in-swap compression) paramaters in kernel.
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.zpool=zsmalloc"
    "zswap.max_pool_percent=50"
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
      randomEncryption.enable = true;
    }
  ];

  services.xserver.enable = true;
  security.polkit.enable = true;
  services.gvfs.enable = true;
  programs.dconf.enable = true;

  # Enable the niri Wayland window manager.
  programs.niri.enable = true;

  # Battery support. (Some desktop environments won't see the battery without this service.)
  services.upower.enable = true;

  # Be on the bleeding edge of Nix versions.
  nix.package = pkgs.nixVersions.latest;

  system.stateVersion = "25.11";
}
