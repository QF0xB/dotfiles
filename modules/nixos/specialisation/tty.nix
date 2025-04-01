{
  isLaptop,
  lib,
  ...
}:

let
  inherit (lib) mkForce;
in
{
  specialisation = {
    tty.configuration = {
      hm.qnix.headless = mkForce true;
    };
  };
}
