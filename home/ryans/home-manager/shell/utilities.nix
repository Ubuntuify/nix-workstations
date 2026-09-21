{
  pkgs,
  lib,
  config,
  nixosConfig,
  ...
} @ args: let
  isNixOS = builtins.hasAttr "nixosConfig" args;
in {
  programs.bat = {
    enable = true;
    config.theme = "Nord";
  };

  programs.cava = {
    enable = !pkgs.stdenv.hostPlatform.isDarwin;
    settings = {
      color = {
        background = "'#232136'";
        gradient = 1;
        gradient_count = 6;
        gradient_color_1 = "'#3e8fb0'";
        gradient_color_2 = "'#9ccfd8'";
        gradient_color_3 = "'#c4a7e7'";
        gradient_color_4 = "'#ea9a97'";
        gradient_color_5 = "'#f6c177'";
        gradient_color_6 = "'#eb6f92'";
      };
    };
  };

  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [".git/" "*.bak" ".DS_Store"];
  };

  home.packages =
    [
      # Packages that exist both on Linux and Darwin systems.
      pkgs.zip
      pkgs.xz
      pkgs.unzip
      pkgs._7zz
      pkgs.file
      pkgs.lstr
      pkgs.which
      pkgs.gnused
      pkgs.gnutar
      pkgs.gawk
      pkgs.zstd
      pkgs.btop
    ]
    ++
    # Packages that only exist on Linux, and should not be added to
    # home.packages on darwin systems.
    (lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
      pkgs.lsof
      pkgs.ethtool
      pkgs.lm_sensors
      pkgs.pciutils
      pkgs.usbutils
    ]);

  # Nix can start taking a lot of space, as it doesn't remove old versions of
  # packages automatically. Since we're already using nh (yet another nix CLI
  # helper), use that to clean up.

  # This checks if there's already a corresponding configuration in nixosConfig
  # (there's none for nix-darwin), and removes it from home-manager if there is.
  programs.nh = {
    enable = !nixosConfig.programs.nh.enable;
    flake = "${config.xdg.dataHome}/nix-workstations"; # use default flake location
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--verbose --keep-since 7d --optimise";
    };
  };
}
