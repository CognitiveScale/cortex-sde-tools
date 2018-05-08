let

    default =
        {
            # git describe: 16.09-beta-37519-g33cfad9a111
            #rev = "ee28e35ba37ab285fc29e4a09f26235ffe4123e2";
            #sha256 = "0a6xrqjj2ihkz1bizhy5r843n38xgimzw5s2mfc42kk2rgc95gw5";

            # git describe: 18.03-beta-7687-g75cfbdf33b0
            rev = "75cfbdf33b0423c2bd8f9fb20393267ef02bbf9d";
            sha256 = "1l6b6gm2r0hk54nlc22b6mwm7xlvq9vpc8z4vr37i33mm81vf5mf";

            bootPkgs = import <nixpkgs> {};
            nixpkgsArgs = { config.allowUnfree = true; };
            overlay = import ./overrides/nixpkgs;
            srcFilter = p: t:
                baseNameOf p != "result" && baseNameOf p != ".git";
            haskellArgs = {};
            pythonArgs = {};
        };

in

{ rev ? default.rev
, sha256 ? default.sha256
, bootPkgs ? default.bootPkgs
, nixpkgsArgs ? default.nixpkgsArgs
, srcFilter ? default.srcFilter
, nixpkgsOverlay ? default.overlay
, haskellArgs ? default.haskellArgs
, pythonArgs ? default.pythonArgs
}:

generator:

let

    nixpkgsPath =
        bootPkgs.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            inherit rev sha256;
        };

    origNixpkgs = import nixpkgsPath { config = {}; };

    lib = import ./lib origNixpkgs;

    morePkgs = self: super:
        let
            args = { nixpkgs = self; inherit pkgs; };
            overriding =
                path: (super.makeOverridable (import path) args).override;
            h = overriding ./haskell.nix haskellArgs;
            p = overriding ./python.nix pythonArgs;
            tools = import ./tools self.callPackage;
            callPackage = p:
                let pkg = (self.callPackage (import p) {});
                in
                if pkg ? overrideAttrs
                then pkg.overrideAttrs (attrs:
                    if attrs ? src
                    then { src = builtins.filterSource srcFilter attrs.src; }
                    else {})
                else pkg;
        in
        {
            haskellPackages = h.haskellPackages;
            pythonPackages = p.pythonPackages;
            pkgsMake = {
                inherit lib;
                call = {
                    package = callPackage;
                    haskell = {
                        lib = h.callHaskellLib;
                        app = h.callHaskellApp;
                    };
                    python = p.callPython;
                };
                env = { haskell = h.env; python = p.env; };
            };
        } // tools // pkgs;

    overlays = [ morePkgs nixpkgsOverlay ];

    nixpkgs = import origNixpkgs.path (nixpkgsArgs // { inherit overlays; });

    args = {
        inherit lib;
        call = nixpkgs.pkgsMake.call;
    };

    pkgs = generator args;

in

pkgs // { inherit nixpkgs; env = nixpkgs.pkgsMake.env; }
