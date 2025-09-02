{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in {
  # GUI applications, applications such as calibre, etc.

  home.packages =
    [
    ]
    ++ (lib.optionals isLinux [
      pkgs.nemo-with-extensions # file manager

      pkgs.novelwriter # novel writer / scrivener alternative
      pkgs.alegreya # font for writing (serif-font)
    ]);

  # nemo - file manager, required association
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = lib.optionals isLinux ["nemo.desktop"];
    "application/x-gnome-saved-search" = lib.optionals isLinux ["nemo.desktop"];
  };

  dconf.settings."org/cinnamon/desktop/applications/terminal".exec = "alacritty";

  # calibre - EPUB / book reader
  programs.calibre = {
    enable = true;

    plugins = [
    ];
  };
}
