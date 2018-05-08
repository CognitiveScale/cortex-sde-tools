let

    default =
        {
            ghcVersion = "ghc822";
            overrides = import ./overrides/haskell;
            srcFilter = p: t:
                baseNameOf p != "result"
                    && baseNameOf p != ".git"
                    && baseNameOf p != ".stack-work";
            envMoreTools = nixpkgs:
                [
                    (nixpkgs.callPackage (import ./tools/nix-tags-haskell) {})
                    (nixpkgs.callPackage (import ./tools/cabal-new-watch) {})
                    nixpkgs.haskellPackages.cabal2nix
                    nixpkgs.haskellPackages.c2hs
                    nixpkgs.haskellPackages.cabal-install
                    nixpkgs.haskellPackages.ghcid
                ];
        };

in

{ nixpkgs
, pkgs
, ghcVersion ? default.ghcVersion
, overrides ? default.overrides
, srcFilter ? default.srcFilter
, envMoreTools ? default.envMoreTools nixpkgs
}:

let

    lib = import ./lib nixpkgs;

    ghc = builtins.getAttr ghcVersion nixpkgs.haskell.packages;

    mkDerivation = hPkgs: args:
        hPkgs.mkDerivation
            (lib.nix.recursiveUpdate
                args
                { passthru.envArgs.haskell = args; });

    haskellPackages =
        ghc.override {
            overrides = self: super:
                { mkDerivation = mkDerivation super; }
                    // pkgs
                    // (overrides nixpkgs self super);
        };

    deriveHaskell = p:
        if builtins.pathExists (builtins.toPath (p + "/default.nix"))
        then p
        else
            let
                findCabal =
                    lib.nix.composed [
                        (lib.nix.findFirst
                            (lib.nix.hasSuffix ".cabal")
                            ("error"))
                        builtins.attrNames
                        builtins.readDir
                    ];
            in
            nixpkgs.stdenv.mkDerivation {
                name = lib.nix.composed [
                    (x: x + "-cabal2nix")
                    (lib.nix.removeSuffix ".cabal")
                    (x:
                        if x == "error"
                        then throw ("no Cabal file found: " + p)
                        else x)
                    (x: if x == "error" then findCabal p else x)
                    findCabal
                    dirOf
                ] p;
                src = builtins.filterSource srcFilter p;
                buildInputs = [ nixpkgs.cabal2nix ];
                phases = [ "installPhase" ];
                installPhase =
                    ''
                    mkdir "$out"
                    cabal2nix "$src" > "$out/default.nix"
                    '';
            };

    callHaskell = p:
        lib.nix.composed
            [ lib.haskell.dontHaddock (lib.haskell.filterSource srcFilter) ]
            (haskellPackages.callPackage (import (deriveHaskell p)) {});

    callHaskellApp = p: lib.haskell.disableSharedExecutables (callHaskell p);

    envPkgs =
        builtins.filter (e: e ? envArgs.haskell) (builtins.attrValues pkgs);

    envFilter = drv:
        drv != null && ! builtins.elem drv (builtins.attrValues pkgs);

    envArg = a:
        lib.nix.filter envFilter
            (lib.nix.unique
                (builtins.foldl'
                    (acc: s:
                        if builtins.hasAttr a s.envArgs.haskell
                        then builtins.getAttr a s.envArgs.haskell ++ acc
                        else acc)
                    []
                    envPkgs));

    env =
        (haskellPackages.mkDerivation {

            pname = "env-haskell";
            version = "0.0.1.0";
            license = lib.nix.licenses.bsd3;

            buildDepends = envArg "buildDepends";
            setupHaskellDepends = envArg "setupHaskellDepends";
            libraryHaskellDepends = envArg "libraryHaskellDepends";
            executableHaskellDepends = envArg "executableHaskellDepends";

            buildTools = envArg "buildTools";
            libraryToolDepends = envArg "libraryToolDepends";
            executableToolDepends = envArg "executableToolDepends";
            testToolDepends = envArg "testToolDepends";
            benchmarkToolDepends = envArg "benchmarkToolDepends";

            pkgconfigDepends = envArg "pkgconfigDepends";
            libraryPkgconfigDepends = envArg "libraryPkgconfigDepends";
            executablePkgconfigDepends = envArg "executablePkgconfigDepends";
            testPkgconfigDepends = envArg "testPkgconfigDepends";
            benchmarkPkgconfigDepends = envArg "benchmarkPkgconfigDepends";

            testDepends = envArg "testDepends";
            testHaskellDepends = envArg "testHaskellDepends";
            testSystemDepends = envArg "testSystemDepends";

            benchmarkDepends = envArg "benchmarkDepends";
            benchmarkHaskellDepends = envArg "benchmarkHaskellDepends";
            benchmarkSystemDepends = envArg "benchmarkSystemDepends";

        }).env.overrideAttrs (old1: {
            nativeBuildInputs = old1.nativeBuildInputs ++ envMoreTools;
            passthru.withEnvTools = f: env.overrideAttrs (old2: {
                nativeBuildInputs =
                    old2.nativeBuildInputs ++ f nixpkgs;
            });
        });

in

{
    inherit haskellPackages callHaskellApp env;
    callHaskellLib = callHaskell;
}
