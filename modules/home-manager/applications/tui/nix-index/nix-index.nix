{
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.applications.tui.nix-index;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.tui.nix-index = {
    enable = mkEnableOption "Command not found database" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.nix-index.enable = true;

    qnix.persist = {
      home = {
        cache.directories = [ ".cache/nix-index" ];
      };
    };
  };
}
