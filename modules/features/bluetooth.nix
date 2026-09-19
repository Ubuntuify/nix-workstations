{
  hardware.bluetooth.enable = true;

  # Enables AirPlay (apple's streaming protocol)
  services.avahi.enable = true;
  services.avahi = {
    nssmdns4 = true;
    nssmdns6 = true;

    publish = {
      enable = true;
      userServices = true;
      domain = true;
    };
  };

  # Enables audio enhancement for bluetooth speakers
  services.pipewire.wireplumber.extraConfig."10-bluetooth-enhancements"."monitor.bluez.properties" = {
    # Enables required roles for this bluetooth device.
    "bluez5.roles" = ["hfp_hf" "hfp_ag" "a2dp_sink" "a2dp_source" "bap_sink" "bap_source"];

    # Default baseline configurations for this BT device.
    "bluez5.enable-sbc-xq" = true;
    "bluez5.enable-msbc" = true;
    "bluez5.enable-hw-volume" = true;
  };

  services.pipewire = {
    raopOpenFirewall = true; # opens UDP ports 6001-6002

    extraConfig.pipewire = {
      "10-airplay"."context.modules" = [{name = "libpipewire-module-raop-discover";}];
    };
  };
}
