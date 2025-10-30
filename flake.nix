{
  inputs = {
    garnix-lib.url = "github:garnix-io/garnix-lib";
    UptimeKuma.url = "github:garnix-io/uptime-kuma-module";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.garnix.io" ];
    extra-trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };

  outputs = inputs: inputs.garnix-lib.lib.mkModules {
    modules = [
      inputs.UptimeKuma.garnixModules.default
    ];

    config = { pkgs, ... }: {
      uptimeKuma = {
        uptimeKuma-project = {
          path = "/";
          port = 3001;
        };
      };

      garnix.deployBranch = "master";
    };
  };
}
