{lib, ...}: {
  options.custom = {
    # System users are defined within the system.toml located within their configuration
    # paths, under [users].sysadmin
    systemUser = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "The primary user (sysadmin) managing the system. The flake repository dedicated to building the system should be owned by this user.";
    };
  };
}
