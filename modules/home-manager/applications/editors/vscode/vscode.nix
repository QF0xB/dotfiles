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

      package = pkgs.vscodium;

      profiles.default = {
        userSettings = {
          "keyboard.dispatch" = "keyCode";
        };
        extensions = with pkgs; [
          vscode-extensions.zhwu95.riscv
          proto.vscode-extensions.hm.riscv-venus
          proto.vscode-extensions.sunshaoce.risc-v
        ];
      };
    };

    qnix.persist.home.directories = [
      ".config/VSCodium"
      ".vscode-oss"
    ];
  };
}
