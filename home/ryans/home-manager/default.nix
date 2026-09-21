{
  imports = [
    ./applications/alacritty.nix
    ./applications/firefox.nix
    ./applications/social.nix
    ./applications/miscellaneous.nix

    ./shell/fish.nix
    ./shell/fastfetch/default.nix
    ./shell/git.nix
    ./shell/lf/default.nix
    ./shell/neovim.nix
    ./shell/utilities.nix

    ./desktop-environment/niri/default.nix
    ./desktop-environment/dank-material-shell.nix
    ./desktop-environment/theme.nix

    ./utilities/linux.nix
  ];

  xdg.enable = true;

  home.stateVersion = "26.05";
}
