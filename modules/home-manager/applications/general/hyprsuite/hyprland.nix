{
  options,
  config,
  lib,
  ...
}:

let
  cfg = config.qnix.home.applications.general.hyprsuite;
in
{
  options.qnix.home.applications.general.hyprsuite.hyprland = with lib; {
    enable = mkEnableOption "hyprland home module";
  };

  config = {
    wayland.windowManager = {
      hyprland = {
        enable = cfg.hyprland.enable;
        package = null;
        portalPackage = null;

        settings = {
          "$mod" = "super";
          bind =
            [
              "$mod, return, exec, kitty #Kitty"
              "$mod CTRL, return, exec, kitty --class floating"
            ]
            ++ (
              let
                # Import your custom lib.nix which exports custom.parseInt.
                parseInt = lib.custom.parseInt;

                workspaces = {
                  "1" = "58";
                  "2" = "59";
                  "3" = "60";
                  "4" = "44";
                  "5" = "45";
                  "6" = "46";
                  "7" = "30";
                  "8" = "31";
                  "9" = "32";
                  "10" = "65";
                };

                # Mapping for code comments.
                keyMap = {
                  "58" = "m";
                  "59" = ",";
                  "60" = ".";
                  "44" = "j";
                  "45" = "k";
                  "46" = "l";
                  "30" = "u";
                  "31" = "i";
                  "32" = "o";
                  "65" = "space";
                };

                # When displaying a workspace as a key we want "10" to show as "0".
                conv = ws: if ws == "10" then "0" else ws;

                # Helper to lookup the comment for a code.
                lookupCodeComment =
                  code:
                  let
                    key = builtins.toString code;
                    names = builtins.attrNames keyMap;
                  in
                  if builtins.elem key names then builtins.getAttr key keyMap else key;

                # Define six transformation functions producing binding lines.
                transFns = [
                  # Group 1: Basic workspace binding (with converted key).
                  (ws: code: "bind = $mainMod, " + conv ws + ", workspace, " + conv ws)
                  # Group 2: Code version binding (original workspace key) with comment.
                  (
                    ws: code:
                    "bind = $mainMod, code:"
                    + builtins.toString code
                    + ", workspace, "
                    + ws
                    + " #"
                    + lookupCodeComment code
                  )
                  # Group 3: Move binding (with converted key).
                  (ws: code: "bind = $mainMod+SHIFT+CTRL, " + conv ws + ", movetoworkspace, " + conv ws)
                  # Group 4: Move code version binding with comment.
                  (
                    ws: code:
                    "bind = $mainMod+SHIFT+CTRL, code:"
                    + builtins.toString code
                    + ", movetoworkspace, "
                    + ws
                    + " #"
                    + lookupCodeComment code
                  )
                  # Group 5: Move silent binding (with converted key).
                  (ws: code: "bind = $mainMod CTRL, " + conv ws + ", movetoworkspacesilent, " + conv ws)
                  # Group 6: Move silent code version binding with comment.
                  (
                    ws: code:
                    "bind = $mainMod CTRL, code:"
                    + builtins.toString code
                    + ", movetoworkspacesilent, "
                    + ws
                    + " #"
                    + lookupCodeComment code
                  )
                ];

                # Sort workspace keys numerically using custom.parseInt.
                sortedKeys = builtins.sort (a: b: if parseInt a < parseInt b then true else false) (
                  builtins.attrNames workspaces
                );

                # For each workspace key, apply all six transformation functions.
                allLines = builtins.concatLists (
                  map (
                    ws:
                    let
                      code = workspaces.${ws};
                    in
                    builtins.map (fn: fn ws code) transFns
                  ) sortedKeys
                );
              in
              allLines
            );
        };
      };
    };
  };
}
