getDeps:

let
    pkgsMake = import ../. {};
    dummy    = pkgsMake (_ : {});
    pp       = dummy.nixpkgs.pythonPackages;
    deps     = getDeps { nixpkgs = dummy.nixpkgs; };

    libraries   = if deps ? libraries then deps.libraries else [];
    envWithLibs =
        pp.python.buildEnv.override { extraLibs = libraries; ignoreCollisions = true; };

    defaultTools = [ pp.yapf pp.ipython pp.flake8 pp.pylint ];
    tools        = defaultTools ++ (if deps ? tools then deps.tools else []);
    envWithTools =
        envWithLibs.env.overrideAttrs (oldAttrs: { nativeBuildInputs = oldAttrs.nativeBuildInputs ++ tools; });
in

envWithTools
