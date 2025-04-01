{
  lib,
  ...
}:

let
  inherit (lib) mkForce;
in
{
  specialisation = {
    no-citrix.configuration = {
      hm.qnix = {
        applications.work.citrix.enable = mkForce false;
      };
    };
  };
}
