{
  config,
  modules,
  outputs,
  ...
}: {
  imports = [
    modules.hardware-specific.wsl.nvidia
    modules.security.sops
    (outputs.lib.users.getNixUserModule "ryans")
  ];

  home-manager.users.${config.custom.systemUser} = outputs.lib.home-manager.mkHomeEntry {
    user = config.custom.systemUser;
    options = {roles.graphics = false;};
  };
}
