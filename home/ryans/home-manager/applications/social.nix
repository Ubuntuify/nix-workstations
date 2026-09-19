{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = lib.optionals (pkgs.stdenv.hostPlatform.isLinux && config.perpensity.roles.graphics) [
    pkgs.legcord
  ];
}
