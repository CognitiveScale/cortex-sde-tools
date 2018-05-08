{ call, lib, ...}:

let 
    allFiles = builtins.readDir ./.;
    keepDirs = name: type: type == "directory";
    dirs = lib.nix.filterAttrs keepDirs allFiles;
    callPython = name: type: call.python (./. + "/${name}");
in 
    lib.nix.mapAttrs callPython dirs
