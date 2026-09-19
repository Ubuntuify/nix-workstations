# Unlike other modules, this module requires some stuff to be passed in to check for some features on Macbooks.
# For example, 13" Macbooks still have a touch bar that requires configuration and newer devices have a notch.
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.apple-silicon.nixosModules.apple-silicon-support # make sure that the Apple Silicon support module is loaded.
  ];

  options.perpensity.asahi = {
    firmwareHash = lib.mkOption {
      type = lib.types.str;
    };
    touchBarSupport = lib.mkEnableOption "touch bar support using tiny-dfr, only applicable to 13\" Macbook Pro (pre-refresh)";
    showNotchArea = lib.mkEnableOption "notch space on supporting devices.";
  };

  config = {
    hardware.asahi.enable = true;

    environment.systemPackages = with pkgs; [
      asahi-bless # allows switching boot device, similar to Startup Disk on MacOS (or the bless utility).
      asahi-btsync # allows sync of bluetooth devices between containers

      # Custom packages
      (pkgs.callPackage ../../pkgs/asahi/asahi-wrappers.nix {})
    ];

    # Sync Bluetooth from MacOS to keep pairing ability between operating systems.
    systemd.services."asahi-btsync" = {
      enable = true;
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.asahi-btsync}/bin/asahi-btsync sync";
      };
    };

    hardware.asahi.peripheralFirmwareDirectory =
      (fetchTree {
        # use fetchTree to automatically pull the firmware/calibration data from the ESP partition, without manual
        type = "path"; # setup
        path = "/boot/vendorfw/";
        narHash = config.perpensity.asahi.firmwareHash;
      }).outPath;

    hardware.asahi.avd = {
      enable = lib.mkDefault true; # enable hardware acceleration of decoding/encoding media (e.g. HEVC and H264)
      vaapi-support = lib.mkForce true; # required for desktop integration through VA-API
    };

    # You can't touch EFI variables on an Asahi Linux system, and doing so will cause the switch to fail.
    boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

    # Configurable parts for Apple Macbook quirks, such as the Touch Bar and the Notch on older and newer devices
    # respectively.
    hardware.apple.touchBar.enable = config.perpensity.asahi.touchBarSupport;
    boot.kernelParams = lib.optionals config.perpensity.asahi.showNotchArea ["appledrm.show_notch=1"];
  };
}
