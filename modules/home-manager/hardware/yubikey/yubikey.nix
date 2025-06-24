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

  # config = {
  # write Yubico file
  # xdg.configFile."Yubico/u2f_keys".text = ''
  # lcqbraendli:WL1eNX3H4cqCpOdlFLskeKHVkf+SUVng34Ch6rxwn5gw+bJrTyH7wBaYE/iY0Rl4Ab0mNJrTtoUqjLaRNvhWbA==,DX5g1dye2T+mX8tNyMg05W3NrbDE527OCWv6BcUgb63H0zEu4BEl9zWlf3tVOINlqyHcS988QVzfzfHKXT5Abw==,es256,+presence
  # lcqbraendli:m0YQcNcDr6IuR4uyZPsfGIH5cyXTQ83xMDwGGXfcHm1cYKBlYW0Vk2iM2OgIGFC4RhoC0fxNf2xzS4JQxZJ8+A==,larZDQZG5KERhbGuWutQyokSA/fcCWlnff4K32SCIOvj4e8PI2EnjCY7q5KsAuGQEdurx0PVayHltNhWW54Hyg==,es256,+presence
  # '';

  # };
}
