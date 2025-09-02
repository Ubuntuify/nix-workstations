{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.pwvucontrol];

  security.rtkit.enable = true; # enable realtime audio processing

  services.pipewire = {
    enable = true;

    # Pipewire pipes into other protocols for compatibility with older applications.
    # Other options include JACK, which are disabled here to save on space.
    pulse.enable = true;
    alsa.enable = true;

    # (*)Not recommended, but I want systemwide audio.
    systemWide = lib.mkDefault true;
  };
}
