nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "plotly";
    version = "2.5.1";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "0scshpppsc4m84w9a70zqy6bsg3ldj3blkw55kc83kvicb1idn4x";
    };

    propagatedBuildInputs = with self; [
        decorator
        nbformat
        pytz
        requests
        six
    ];

    # DESIGN: no tests in archive
    doCheck = false;

}
