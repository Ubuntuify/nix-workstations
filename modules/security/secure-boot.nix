{
  pkgs,
  lib,
  ...
}: {
  # Only activate this module after doing the following steps:
  # `sudo sbctl create-keys`
  # `sudo sbctl enroll-keys --microsoft --firmware-builtin`

  environment.systemPackages = [pkgs.sbctl]; # sbctl is required for self-signing Secure Boot keys

  boot.loader.limine = {
    enable = true;
    secureBoot = lib.mkDefault true;
  };
}
