nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "spacy";
    version = "2.0.11";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "08d4bf9r8gykl921l2lbxwcspbcdvdc257dmkqry88jjjvkhdnyd";
    };

    # DESIGN: Nix is already on the latest, and I suspect Spacy will be fine.
    preConfigure = ''
        sed -i -e 's/regex==2017.4.5/regex>=2017.4.5/' setup.py
    '';

    buildInputs = with self; [ cython pip ];

    propagatedBuildInputs = with self; [
        cymem
        dill
        murmurhash
        numpy
        pathlib
        plac
        preshed
        regex
        thinc
        ujson
    ];

    checkInputs = with self; [ mock pytest ];

    doCheck = false;

}
