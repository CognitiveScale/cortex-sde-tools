nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "imbalanced-learn";
    version = "0.3.3";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "1r5js9kw6rvmfvxxkfjlcxv5xn5h19qvg7d41byilxwq9kd515g4";
    };

    checkInputs = with self; [ nose pytest ];

    propagatedBuildInputs = with self; [
        numpy
        scikitlearn
        scipy
    ];

    # DESIGN: fragile tests: equality on floats, whitespace
    doCheck = false;

}
