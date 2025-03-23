{
  config,
  lib,
  host,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.gui.orcaslicer;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.qnix.applications.gui.orcaslicer = {
    enable = mkEnableOption "orcaslicer" // {
      default = host == "QPC";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.symlinkJoin {
        name = "orca-slicer";
        paths = [ pkgs.orca-slicer ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/orca-slicer \
          --set __GLX_VENDOR_LIBRARY_NAME mesa \
          --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json
        '';
        meta.mainProgram = "orca-slicer";
      })
    ];
  };
}
