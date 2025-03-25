{
  lib,
  ...
}:

let
  inherit (lib) mkOption types;
in
{
  options.qnix.applications.shells = {
    symlinks = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Symlinks to create in format { dest = src; }";
    };
  };
}
