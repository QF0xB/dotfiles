{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.qnix.applications.utils.nemo;
  inherit (lib) getExe;
in
{
  options.qnix.applications.utils.nemo = with lib; {
    enable = mkEnableOption "nemo file-manager" // {
      default = !config.qnix.headless;
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      nemo-with-extensions
      nemo-fileroller
      file-roller
      webp-pixbuf-loader # for webp thumbnails
      xdg-terminal-exec
      p7zip-rar # encrypted archives
    ];

    xdg = {
      #fix mimetype
      mimeApps.defaultApplications = {
        "inode/directory" = "nemo.desktop";

        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/vnd.rar" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-bzip2-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
      };
    };

    gtk.gtk3.bookmarks =
      let
        homeDir = config.home.homeDirectory;
      in
      [
        "file://${homeDir}/Downloads"
        "file://${homeDir}/projects"
        "file://${homeDir}/projects/dotfiles"
        "file://${homeDir}/cache-projects/nixpkgs"
        "file://${homeDir}/Documents"
        "file:///persist Persist"
      ];

    dconf.settings = {
      # fix open in terminal
      "org/gnome/desktop/applications/terminal" = {
        exec = getExe pkgs.xdg-terminal-exec;
      };
      "org/cinnamon/desktop/applications/terminal" = {
        exec = getExe pkgs.xdg-terminal-exec;
      };
      "org/nemo/preferences" = {
        default-folder-viewer = "list-view";
        show-hidden-files = true;
        start-with-dual-pane = true;
        date-format-monospace = true;
        # needs to be a uint64!
        thumbnail-limit = lib.hm.gvariant.mkUint64 (100 * 1024 * 1024); # 100 mb
      };
      "org/nemo/window-state" = {
        sidebar-bookmark-breakpoint = 0;
        sidebar-width = 180;
      };
      "org/nemo/preferences/menu-config" = {
        selection-menu-make-link = true;
        selection-menu-copy-to = true;
        selection-menu-move-to = true;
      };
    };

    wayland.windowManager.hyprland.settings = {
      # disable transparency for file delete dialog
      windowrulev2 = [ "forcergbx,floating:1,class:(nemo)" ];
    };

    qnix.persist = {
      home = {
        directories = [
          # folder preferences such as view mode and sort order
          ".local/share/gvfs-metadata"
        ];
        cache.directories = [
          # thumbnail cache
          ".cache/thumbnails"
        ];
      };
    };
  };
}
