{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [inputs.nixos-wsl.nixosModules.default]; # import support module

  options.perpensity = {
    wsl.graphics = lib.mkEnableOption "enable WSLg (graphics, or hardware acceleration)";
  };

  config.wsl = {
    enable = lib.mkForce true;

    interop.includePath = true;
    interop.register = true;

    usbip.enable = true;

    useWindowsDriver = true;

    wrapBinSh = true;
  };
}
