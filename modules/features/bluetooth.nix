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

  services.pipewire = {
    raopOpenFirewall = true; # opens UDP ports 6001-6002

    extraConfig.pipewire = {
      "10-airplay"."context.modules" = [{name = "libpipewire-module-raop-discover";}];
    };
  };
}
