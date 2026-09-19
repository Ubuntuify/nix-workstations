{
  inputs,
  lib,
  pkgs,
  ...
}: {
  # Fonts often have licensing agreements which make them 'non-free' software. Allow these particular
  # fonts to be downloaded without seeing unfree to the entire flake.
  nixpkgs.config.joypixels.acceptLicense = true;
  nixpkgs.config.allowUnfreePackages = ["sf-pro" "corefonts" "vista-fonts" "joypixels"];

  fonts.packages = with pkgs; [
    # Install Windows fonts.
    corefonts
    vista-fonts

    # Install default MacOS' San Francisco font
    nur.repos.sagikazarmark.sf-pro

    # Other open source fonts.
    noto-fonts
    font-awesome
    joypixels
    open-sans
    jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
  fonts.fontconfig = {
    useEmbeddedBitmaps = true; # use embedded font bitmaps like in Calibri
    subpixel.rgba = lib.mkDefault "rgb"; # subpixel hinting through pixel layout, which may differ per system.
  };

  fonts.enableDefaultPackages = true; # enable default fonts (for linux)
}
