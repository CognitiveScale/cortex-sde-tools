pkgs: self: super:


super.buildPythonPackage rec {

    pname = "pyjq";
    version = "2.1.0";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "1qhgsv0vsyz3gxnjfk22m5mn5kwwr91j763hhnfc42yr3a2rry7n";
    };

    nativeBuildInputs = with pkgs; [ autoconf automake libtool ];
    buildInputs = with pkgs; [ jq ];
    propagatedBuildInputs = with self; [ six ];
    checkInputs = with self; [ mock];
    #doCheck = false;

}
