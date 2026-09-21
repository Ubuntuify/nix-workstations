{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  services.openssh.generateHostKeys = lib.mkForce true; # OpenSSH is required for converting keys into sops keys,
  # so set this as default.

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    validateSopsFiles = true;

    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key" # Use the system's SSH key to unlock the secrets
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true; # Auto generates a key, if it doesn't exist
    };
  };

  # Add packages required for sops-nix secret keeping, so we don't have
  # to add it to the profile manually.
  environment.systemPackages = [pkgs.age pkgs.sops];
}
