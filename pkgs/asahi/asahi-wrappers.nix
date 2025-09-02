{
  stdenvNoCC,
  writeShellScriptBin,
  pkgs,
}: let
  # Use `run0` for script elevation as a desktop environment can give a GUI prompt.
  reboot-to-macos = writeShellScriptBin "reboot-to-macos" ''
    ${pkgs.systemd}/bin/run0 ${pkgs.asahi-bless}/bin/asahi-bless --next --set-boot-macos -y \
      && ${pkgs.systemd}/bin/systemctl reboot
  '';
in
  stdenvNoCC.mkDerivation {
    name = "asahi-wrappers";
    version = 1.0;
    buildInputs = with pkgs; [
      # Dependencies
      asahi-bless

      # Scripts
      reboot-to-macos
    ];

    src = ./.;

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${reboot-to-macos}/bin/reboot-to-macos $out/bin/reboot-to-macos
    '';
  }
