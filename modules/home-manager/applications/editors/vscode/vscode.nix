{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.qnix.applications.editors.vscode;
  inherit (lib) mkEnableOption;
in
{
  options.qnix.applications.editors.vscode = {
    enable = mkEnableOption "vscode" // {
      default = !config.qnix.headless;
    };
  };

  config = {
    programs.vscode = {
      inherit (cfg) enable;

      package = pkgs.code-cursor;

      profiles.default = {
        userSettings = {
          "files.autoSave" = "onFocusChange";
          "keyboard.dispatch" = "keyCode";
          "redhat.telemetry.enabled" = "false";
        };
        extensions = with pkgs; [
          # RiscV
          vscode-extensions.zhwu95.riscv
          proto.vscode-extensions.hm.riscv-venus
          proto.vscode-extensions.sunshaoce.risc-v

          # Nix
          vscode-extensions.jnoortheen.nix-ide
          vscode-extensions.mkhl.direnv

          # Python
          vscode-extensions.ms-python.python

          # CPP
          vscode-extensions.ms-vscode.cpptools-extension-pack

          # VIM
          vscode-extensions.vscodevim.vim

          # Java
          vscode-extensions.vscjava.vscode-java-pack
          vscode-extensions.vscjava.vscode-spring-initializr
        ];
      };
    };

    qnix.persist.home.directories = [
      ".config/VSCodium"
      ".vscode-oss"
      ".config/Cursor"
    ];
  };
}
