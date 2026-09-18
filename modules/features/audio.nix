{pkgs, ...}: {
  environment.systemPackages = [pkgs.pwvucontrol];

  security.rtkit.enable = true; # enable realtime audio processing

  services.pipewire.wireplumber = {
    enable = true;

    extraConfig = {
      # Enable pipewire codecs through bluetooth (A2DP/HFP)
      "10-audio-enhancements"."monitor.bluez.properties" = {
        # Enables required roles for this bluetooth device.
        "bluez5.roles" = ["hfp_hf" "hfp_ag" "a2dp_sink" "a2dp_source" "bap_sink" "bap_source"];

        # Default baseline configurations for this BT device.
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
      };
    };
  };

  services.pipewire = {
    enable = true;

    # Pipewire pipes into other protocols for compatibility with older applications.
    # Other options include JACK, which are disabled here to save on space.
    pulse.enable = true;
    alsa.enable = true;
  };
}
