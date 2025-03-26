{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.connection.openssh = {
    enable = mkEnableOption "openssh-server" // {
      default = config.qnix.externally-accessible;
    };

    password-auth = mkEnableOption "passwordauth" // {
      default = false;
    };
  };
}
