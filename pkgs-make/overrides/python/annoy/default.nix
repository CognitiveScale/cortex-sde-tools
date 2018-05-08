nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "annoy";
    version = "1.11.5";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "1jj1cbdm4z0i1v916ssj4lwnzmh2hq3nxw04g3saihslb689c88b";
    };

    checkInputs = with self; [ nose ];

}
