pkgs: self: super:

super.buildPythonPackage rec {

    pname = "scikit-image";
    version = "0.13.1";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "1s4rp162z4lr0yvp01mcahqirbd0r2dwsj9chwhlcgs8yzfpjf1m";
    };

    buildInputs = with self; [ cython ];

    propagatedBuildInputs = with self; [
        matplotlib
        networkx
        pillow
        scipy
        six
        pywavelets
    ];

    # DESIGN: tests fail because the loader cannot create test objects
    doCheck = false;

}
