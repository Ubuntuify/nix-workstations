{
  imports = [
    ./applications/alacritty.nix
    ./applications/firefox.nix
    ./applications/social.nix
    ./applications/miscellaneous.nix
    ./shell/fish.nix
    ./shell/git.nix
    ./shell/lf.nix
    ./shell/neovim.nix
    ./shell/utilities.nix
    ./desktop-environment/niri
    ./desktop-environment/dms.nix
    ./desktop-environment/theme.nix
  ];

  xdg.enable = true;

  home.stateVersion = "26.05";
}
