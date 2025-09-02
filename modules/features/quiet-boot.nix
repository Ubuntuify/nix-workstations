{pkgs, ...}: {
  boot = {
    plymouth = {
      enable = true;

      theme = "hexagon_dots_alt";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["hexagon_dots_alt"];
        })
      ];
    };

    kernelParams = [
      "rd.systemd.show_status=auto"
    ];

    loader.timeout = 0;
  };
}
