nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "scikit-multilearn";
    version = "0.0.5";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "1zgjw2q2b0dgq63f5z1lzfi5b4gly5xdl36zrhzfbn8ax4wjnwj9";
    };

    buildInputs = with self; [ autopep8 ];

    propagatedBuildInputs = with self; [
        bz2file
        liac-arff
        numpy
        python-igraph
        scikitlearn
        scipy
    ];

    doCheck = false;

    preConfigure = ''
        find . -name '*.py' -exec \
            autopep8 --in-place --aggressive {} +
    '';

}
