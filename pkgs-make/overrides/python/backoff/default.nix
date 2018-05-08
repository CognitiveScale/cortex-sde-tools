nixpkgs: self: super:

super.buildPythonPackage rec {

    name = "${pname}-${version}";
    pname = "backoff";
    version = "1.4.3";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "0f4h26papvlb0d22ppgwpmnimnksan2x7nfldpar0zncn2izb3mw";
    };

    doCheck = false;

}
