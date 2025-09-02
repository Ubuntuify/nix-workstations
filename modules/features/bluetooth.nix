{lib, ...}: {
  hardware.bluetooth.enable = true;

  services.blueman.enable = lib.mkDefault true;

  # Enable pipewire codecs through bluetooth (A2DP/HFP)
  services.pipewire.wireplumber.extraConfig = {
    "10-bluez"."monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
    };
  };

  # Enables AirPlay (apple's streaming protocol)
  services.avahi.enable = true;

  services.pipewire = {
    raopOpenFirewall = true; # opens UDP ports 6001-6002

    extraConfig.pipewire = {
      "10-airplay"."context.modules" = [{name = "libpipewire-module-raop-discover";}];
    };
  };
}
