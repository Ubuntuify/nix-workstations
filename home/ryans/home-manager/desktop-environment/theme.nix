{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;

    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
    gtk3.theme = {
      name = "squared-gtk";
      package = pkgs.callPackage ../../../../pkgs/themes/squared-gtk.nix {};
    };
    gtk4.theme = config.gtk.gtk3.theme;
  };
}
