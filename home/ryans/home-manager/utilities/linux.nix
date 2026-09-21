{
  pkgs,
  lib,
  ...
}:
lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
  services.mpris-proxy.enable = true; # enables bluetooth peripherals to have media controls

  # enables KDE connect (requires firewall rules set in NixOS config)
  home.packages = [pkgs.valent];
}
