{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  options.qnix.hardware.yubikey = {
    enable = mkEnableOption "yubikey support" // {
      default = true;
    };
    autolock = mkEnableOption "autolock on removal" // {
      default = true;
    };
  };

  config = {
    # write Yubico file
    xdg.configFile."Yubico/u2f_keys".text =
      "lcqbraendli:NVMp7RLgO9G+J8I+iC2mj0qum9xswAnnYQJU6btNuxcpVrPZFJr96Iwa2qBh2i+MnYc3o701kZLTPlkWd5ztyw==,N2cOgisG3QHs6DDees4w6nrZK2LOKZF6tZQkYGCJ6p52kQ5TG9hreCFBR68UliyOSg4FYinlRK57L0mtVejrbw==,es256,+presence";
  };
}
