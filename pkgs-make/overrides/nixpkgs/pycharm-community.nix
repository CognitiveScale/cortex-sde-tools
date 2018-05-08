self: super:

super.jetbrains.pycharm-community.overrideAttrs (attrs: rec {

    python2 = super.python27.withPackages (pkgs: [pkgs.setuptools]);
    python3 = super.python36.withPackages (pkgs: [pkgs.setuptools]);

    installPhase = attrs.installPhase +
        ''
        ${python2}/bin/python \
            "$out/${attrs.name}/helpers/pydev/setup_cython.py" \
            build_ext \
            --inplace
        ${python3}/bin/python \
            "$out/${attrs.name}/helpers/pydev/setup_cython.py" \
            build_ext \
            --inplace
        '';
})
