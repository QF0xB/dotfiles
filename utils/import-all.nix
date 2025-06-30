# utils/import-all.nix
{
  directory,
  exclude ? [ ],
}:

let
  inherit (builtins)
    readDir
    attrNames
    filter
    elem
    importPath
    ;

  isNixFile = name: name != null && builtins.match ".*\\.nix$" name != null;
  files = filter (name: !(elem name exclude) && isNixFile name) (attrNames (readDir directory));
in
map (name: import (directory + "/${name}")) files
