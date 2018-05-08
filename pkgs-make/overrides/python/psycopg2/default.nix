nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "psycopg2";
    version = "2.7.4";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "02b2yaf1hlwb91xkscbzmajpfj5z3d8yikzh5r48fs8gss8i3xcb";
    };

    propagatedBuildInputs = [ nixpkgs.postgresql ];

    doCheck = false;

}
