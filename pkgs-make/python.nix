let

    default = nixpkgs:
        {
            pyVersion = "36";
            overrides = import ./overrides/python;
            srcFilter = p: t:
                baseNameOf p != "result"
                    && baseNameOf p != ".git"
                    && (! nixpkgs.lib.hasSuffix ".pyc" p)
                    && (! nixpkgs.lib.hasSuffix ".egg-info" p);
            envMoreTools = nixpkgs: [
                nixpkgs.pythonPackages.flake8
                nixpkgs.pythonPackages.ipython
                nixpkgs.pythonPackages.pylint
                nixpkgs.pythonPackages.yapf
            ];
            envPersists = true;
        };

in

{ nixpkgs
, pkgs
, pyVersion ? (default nixpkgs).pyVersion
, overrides ? (default nixpkgs).overrides
, srcFilter ? (default nixpkgs).srcFilter
, envMoreTools ? (default nixpkgs).envMoreTools nixpkgs
, envPersists ? (default nixpkgs).envPersists
}:

let

    lib = import ./lib nixpkgs;

    rawPyPkgs = builtins.getAttr ("python" + pyVersion + "Packages") nixpkgs;

    fullSrcFilter = args:
        if args ? "passthru" && args.passthru ? "srcFilter"
        then p: t: srcFilter p t && args.passthru.srcFilter p t
        else srcFilter;

    filteredSrc = args:
        if args ? "src" && ! lib.nix.isDerivation args.src
        then { src = builtins.filterSource (fullSrcFilter args) args.src; }
        else {};

    buildPy = pyPkgs: args:
        pyPkgs.buildPythonPackage
            (lib.nix.recursiveUpdate
                (args // filteredSrc args)
                { passthru.envArgs.python = args; });

    pythonPackages =
        rawPyPkgs.override {
            overrides = self: super:
                { buildPythonPackage = buildPy super; }
                    // pkgs
                    // (overrides nixpkgs self super);
        };

    sitePackages = pythonPackages.python.sitePackages;

    bootstrappedPip = pythonPackages.bootstrapped-pip;

    callPython = p: pythonPackages.callPackage (import p) {};

    envPkgs =
        builtins.filter (e: e ? envArgs.python) (builtins.attrValues pkgs);

    envFilter = drv:
        drv != null && ! builtins.elem drv (builtins.attrValues pkgs);

    envArg = a:
        lib.nix.filter envFilter
            (lib.nix.unique
                (builtins.foldl'
                    (acc: s:
                        if builtins.hasAttr a s
                        then builtins.getAttr a s ++ acc
                        else acc)
                    []
                    envPkgs));

    env =
        nixpkgs.stdenv.mkDerivation {
            name = "env-python";
            meta.license = lib.nix.licenses.bsd3;
            nativeBuildInputs = envMoreTools;
            propagatedBuildInputs = envArg "propagatedBuildInputs";
            nativePropagatedBuildInputs =
                envArg "nativePropagatedBuildInputs";
            passthru.withEnvTools = f: env.overrideAttrs (old: {
                nativeBuildInputs =
                    old.nativeBuildInputs ++ f nixpkgs;
            });
            inherit envPersists;
            shellHook =
                ''
                shell_cleanup() { rm -rf "$tmp_path"; }
                trap shell_cleanup EXIT
                tmp_path="$(mktemp -d)"
                mkdir -p "$tmp_path/${sitePackages}"
                pip_install_hash="$({
                        find . -name setup.py -type f -exec sha1sum {} +
                        find "${bootstrappedPip}/bin" -type f -exec sha1sum {} +
                    } | sort | sha1sum | cut -d ' ' -f 1)"
                persisted_dir="$(dirname "$tmp_path")/tmp.$pip_install_hash"
                if [ "$envPersists" = "" ] || ! [ -e "$persisted_dir" ]
                then
                    find . -name setup.py -type f | {
                        while read f
                        do
                            setup_dir="$(dirname "$f")"
                            pushd "$setup_dir"
                            PYTHONPATH="$tmp_path/${sitePackages}:$PYTHONPATH" \
                                ${bootstrappedPip}/bin/pip install \
                                -e . \
                                --prefix "$tmp_path" >&2
                            popd
                        done
                    }
                fi
                if [ "$envPersists" = "1" ]
                then
                    if ! [ -e "$persisted_dir" ]
                    then cp -r "$tmp_path" "$persisted_dir"
                    fi
                    export PATH="$persisted_dir/bin:$PATH"
                    export PYTHONPATH="$persisted_dir/${sitePackages}:$PYTHONPATH"
                    echo "nix-shell: state persisted: $persisted_dir" >&2
                else
                    export PATH="$tmp_path/bin:$PATH"
                    export PYTHONPATH="$tmp_path/${sitePackages}:$PYTHONPATH"
                fi
                '';
        };

in

{ inherit pythonPackages callPython env; }
