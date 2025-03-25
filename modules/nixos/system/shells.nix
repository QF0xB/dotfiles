{
  options,
  config,
  lib,
  ...
}:

{
  # options.qnix.system.shell = with lib; {
  # packages = mkOption {
  # type =
  # with types;
  # attrsOf (oneOf [
  # str
  # attrs
  # package
  # ]);
  # apply = custom.mkShellPackages;
  # default = { };
  # description = ''
  # Attrset of shell packages to install and add to pkgs.custom overlay (for compatibility across multiple shells).
  # Both string and attr values will be passed as arguments to writeShellApplicationCompletions
  # '';
  # example = ''
  # shell.packages = {
  # myPackage1 = "echo 'Hello, World!'";
  # myPackage2 = {
  # runtimeInputs = [ pkgs.hello ];
  # text = "hello --greeting 'Hi'";
  # };

  # '';
  # };
  # symlinks = mkOption {
  # type = types.attrsOf types.str;
  # default = { };
  # description = "Symlinks to create in format { dest = src; }";
  # };
  # };
}
