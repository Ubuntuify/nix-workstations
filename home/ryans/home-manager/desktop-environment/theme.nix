{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = config.perpensity.roles.graphics && pkgs.stdenv.hostPlatform.isLinux;

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

  qt = {
    enable = config.perpensity.roles.graphics && pkgs.stdenv.hostPlatform.isLinux;

    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
}
