pkgs: self: super:

super.buildPythonPackage rec {

    pname = "lime";
    version = "0.1.1.29";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "0lr7z5pw62j667qz7z7s7dqdv4p9s0sjcnzq3nm2wvi05mvmz931";
    };

    propagatedBuildInputs = with self; [
        dask  # TODO: remove once scikit-image is updated
        numpy
        scipy
        scikitlearn
        scikitimage
    ];

    doCheck = false;

}
