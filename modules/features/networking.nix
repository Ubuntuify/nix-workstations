{
  lib,
  config,
  ...
}: {
  # Force to localhost to allow dnscrypt-proxy to take over for Secure DNS
  networking.nameservers = lib.mkForce ["127.0.0.1" "::1"];

  # Enable the `iwd` backend for wireless networks (Wi-Fi)
  networking.wireless.iwd = {
    enable = true;
    settings = {
      Settings.AlwaysRandomizeAddress = true;
      Network.MulticastDNS = true;
    };
  };

  # Enable and configure network manager.
  networking.networkmanager.enable = true;
  networking.networkmanager = {
    dns = "none";
    wifi.backend = "iwd";
    wifi.powersave = true;
  };

  # DNS settings (use caching)
  services.dnscrypt-proxy.enable = true;
  services.dnscrypt-proxy.settings = {
    ipv4_servers = true;
    ipv6_servers = true;
    require_dnssec = true;
    pqdnscrypt = true;
    log_files_max_size = 10; # in MB, make sure it doesn't clog up the drive.
    query_log.file = "/var/log/dnscrypt-proxy/query.log"; # check if dnscrypt is actually being used in this environment.

    http3 = true;

    sources.public-resolvers = {
      urls = [
        "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
        "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
      ];
      cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
      minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
    };

    # These servers were chosen due to the ff criteria:
    # - provide DNSSEC and DoH; do no filtering and no logging (at least claim to do so); have servers in Europe
    server_names =
      [
        # Asian-based DNS servers
        "dnscry.pt-hanoi-ipv4"
        "dnscry.pt-hanoi-ipv6"

        "dnscry.pt-doh-hongkong02-ipv4"
        "dnscry.pt-bengaluru-ipv4"
        "dnscry.pt-doh-nuremberg-ipv4"

        # European (EU) DNS servers
        "artikel10-doh-ipv4"
        "artikel10-doh-ipv6"

        "dns4all-ipv4"
        "dns4all-ipv6"

        "dnscry.pt-frankfurt-ipv4"
        "dnscry.pt-frankfurt-ipv6"

        "quad9-doh-ip4-port443-nofilter-pri"
        "quad9-doh-ip6-port443-nofilter-pri"
      ]
      ++ lib.optionals (!config.services.resolved.enable) [
        "cloudflare"
        "cloudflare-ipv6"
        "google"
        "google-ipv6"
      ];
  };

  # Some systemd-resolved settings (fallback for when dnscrypt fails)
  services.resolved.settings.Resolve.DNSSEC = "false";
  services.resolved.settings.Resolve.DNSOverTLS = "opportunistic";

  # Enable IPv6
  networking.enableIPv6 = true;

  # Enable IPv6-mostly networks
  services.clatd.enable = true;
  services.clatd.enableNetworkManagerIntegration = true;

  services.clatd.settings = {
    plat-prefix = "64:ff9b::/96";
  };

  # Configure the device to only use Cloudflare's DNS servers
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
}
