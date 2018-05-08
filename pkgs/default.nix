inputs@{call, ...}:

let
    pythonPkgs = import ./python inputs;
    cortex-sde-tools-installer = call.package ./installer.nix;
in
    pythonPkgs // { inherit cortex-sde-tools-installer; }
