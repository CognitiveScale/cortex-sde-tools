nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "cytoolz";
    version = "0.8.2";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "0ln566dmwcdfil44klrkvwinvfkj9wyv9dwr0kwawpnyfv8jlsj7";
    };

    checkInputs = [ self.nose ];
    propagatedBuildInputs = [ self.toolz ];

    # Disable failing test https://github.com/pytoolz/cytoolz/issues/97
    checkPhase =
        ''
        NOSE_EXCLUDE=test_curried_exceptions nosetests -v $out/${super.python.sitePackages}
        '';

}
