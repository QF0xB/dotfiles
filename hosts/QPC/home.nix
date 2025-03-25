{ ... }:

{
  qnix = {
    applications = {
      virtualisation = {
        virt-manager = {
          enable = true;
          passthrough = true;
        };
      };
    };
  };
}
