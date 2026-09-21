{
  inputs,
  pkgs,
  lib,
  ...
}: let
  background-color = "";
  # 1. Define your mdgreet configuration
  mdgreetConfig = {
    appearance = {
      greeting = "Welcome to NixOS!";
      theme.mode = "dark";
      theme.seed_color = "#89b4fa"; # Catppuccin Mocha Blue
    };
  };

  # 2. Define the niri configuration specifically for the greeter
  niriConfig = pkgs.writeText "niri-greet.kdl" ''
    output * {
      focus-at-startup
      layout {
        background-color "${background-color}"
      }
    }
    hotkey-overlay { skip-at-startup; }

    window-rule {
      match at-startup=true
      open-fullscreen true
    }
    // Launch mdgreet and exit niri when mdgreet is done
    spawn-sh-at-startup "${lib.getExe inputs.mdgreet.packages.${pkgs.stdenv.hostPlatform.system}.default}; ${lib.getExe pkgs.niri} msg action quit --skip-confirmation"
  '';
in {
  # Generate the TOML configuration file
  environment.etc."greetd/mdgreet.toml".source = (pkgs.formats.toml {}).generate "mdgreet.toml" {
    appearance = {
    };
  };

  # Make sure greetd has the necessary directories
  systemd.tmpfiles.settings."10-mdgreet" = {
    "/var/cache/mdgreet".d = {
      mode = "0755";
      user = "greeter";
      group = "greeter";
    };
    "/var/log/mdgreet".d = {
      mode = "0755";
      user = "greeter";
      group = "greeter";
    };
  };

  # Configure the greetd service
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Launch niri with our custom config
        command = "${pkgs.niri}/bin/niri --config ${niriConfig}";
        user = "greeter";
      };
    };
  };

  # Ensure necessary packages are available
  environment.systemPackages = [
    pkgs.niri
    pkgs.dbus-broker
  ];
}
