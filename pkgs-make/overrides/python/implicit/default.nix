pkgs: self: super:


super.buildPythonPackage rec {

    pname = "implicit";
    version = "0.3.3";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "1qnxwgrag6b7j8f6a628s9j8fww9ccqkrhy5zyk3aihan0f6y2j6";
    };

    buildInputs = with self; [ cython ];

    propagatedBuildInputs = with self; [ numpy scipy ];

    # DESIGN: tests don't exist in source, but incorrectly specified in setup.py
    doCheck = false;

}
