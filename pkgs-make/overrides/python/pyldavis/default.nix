pkgs: self: super:

super.buildPythonPackage rec {

    pname = "pyLDAvis";
    version = "2.1.1";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "07al78bryv5571nnjyzw8qwr6w4q6c5l2kck3ry6ss6l5bkqmbs5";
    };

    propagatedBuildInputs = with self; [
        funcy
        future
        jinja2
        joblib
        numexpr
        numpy
        pandas
        scipy
    ];

    checkInputs = with self; [ pytest gensim ];

}
