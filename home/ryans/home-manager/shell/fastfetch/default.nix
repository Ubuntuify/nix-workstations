{
  programs.fastfetch.enable = true;

  programs.fastfetch.settings = builtins.fromJSON (builtins.readFile ./nixos.jsonc);

  xdg.configFile."fastfetch/nixos_logo.webp".source = ./nixos_logo.webp;
}
