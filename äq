{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hm.qnix.applications.ai.ollama;
in
{
  config = lib.mkIf cfg.enable {
    services = {
      open-webui.enable = true;

      ollama = {
        enable = true;

        package = pkgs.master.ollama;
        loadModels = [
          "gpt-oss:20b"
        ];

        acceleration = "cuda";
      };
    };
  };
}
