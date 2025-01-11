{
  config,
  lib,
  pkgs,
  ...
}:

{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../secrets.sops.yaml;
    secrets = {
      backup_server = { };
      backup_password = { };
      upsmon_password = { };
      ldap_password = {
        sopsFile = ../ldap_password.sops.txt;
        format = "binary";
        owner = "nslcd";
      };
    };
  };
}
