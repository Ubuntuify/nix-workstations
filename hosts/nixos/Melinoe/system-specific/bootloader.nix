{
  boot = {
    supportedFilesystems = ["btrfs"];

    loader.limine = {
      enable = true;
      efiSupport = true;
      maxGenerations = 5;
    };
  };
}
