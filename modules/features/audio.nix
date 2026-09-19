{pkgs, ...}: {
  environment.systemPackages = [pkgs.pwvucontrol];

  security.rtkit.enable = true; # enable realtime audio processing

  services.pipewire.wireplumber.enable = true; # enable wireplumber

  services.pipewire.enable = true;
  services.pipewire = {
    # Pipewire pipes into other protocols for compatibility with older applications.
    # Other options include JACK, which are disabled here to save on space.
    pulse.enable = true;
    alsa.enable = true;
  };
}
