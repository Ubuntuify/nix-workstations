{
  lib,
  pkgs,
  ...
}: {
  fonts.enableDefaultPackages = true; # enable default fonts (for linux)

  fonts.packages = [
    # Install Windows fonts.
    pkgs.corefonts
    pkgs.vista-fonts

    # Install default MacOS' San Francisco font
    pkgs.nur.repos.sagikazarmark.sf-pro
    pkgs.inter

    # Other open source fonts.
    pkgs.noto-fonts
    pkgs.font-awesome
    pkgs.joypixels
    pkgs.open-sans
    pkgs.jetbrains-mono

    # CJK Fonts
    pkgs.source-han-serif
    pkgs.source-han-sans
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.wqy_zenhei
    pkgs.microhei
  ];

  fonts.fontconfig.enable = true;
  fonts.fontconfig = {
    useEmbeddedBitmaps = true; # use embedded font bitmaps like in Calibri
    subpixel.rgba = lib.mkDefault "rgb"; # subpixel hinting through pixel layout, which may differ per system.
  };

  # Fonts often have licensing agreements which make them 'non-free' software. Allow these particular
  # fonts to be downloaded without seeing unfree to the entire flake.
  nixpkgs.config.joypixels.acceptLicense = true;
  nixpkgs.config.allowUnfreePackages = ["sf-pro" "corefonts" "vista-fonts" "joypixels"];
}
