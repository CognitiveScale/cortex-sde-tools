inputs@{call, ...}:

let
    pythonPkgs = import ./python inputs;
    cortex-sde-upgrade = call.package ./upgrade.nix;
in
    pythonPkgs // { inherit cortex-sde-upgrade; }
