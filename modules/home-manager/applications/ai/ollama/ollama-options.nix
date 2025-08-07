{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.ai.ollama = {
    enable  = mkEnableOption "ollama" // {
      default = false;
    };
  };
}
