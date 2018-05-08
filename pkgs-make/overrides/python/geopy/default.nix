# DESIGN: Can't use the one in nixpkgs because that is Python 2.7 only

nixpkgs: self: super:

super.buildPythonPackage rec {

    name = "${pname}-${version}";
    pname = "geopy";
    version = "1.12.0";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "186n8qfj352d5pc7qbf3wd0p5ipk5vqajpd3jvx92mgvkkgk2fnm";
    };

    buildInputs = [ nixpkgs.glibcLocales ];

    checkInputs = with self; [ mock tox pylint ];

    preConfigure = ''export LC_ALL="en_US.UTF-8"'';

    # DESIGN: too much testing
    doCheck = false;

}
