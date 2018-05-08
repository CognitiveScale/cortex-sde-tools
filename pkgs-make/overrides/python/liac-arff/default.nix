nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "liac-arff";
    version = "2.1.1";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "05xqr9bp5xg0g6j7f054a5hwkcdhj620pqn09n4gc62kmrj2rvxq";
    };

    doCheck = false;

}
