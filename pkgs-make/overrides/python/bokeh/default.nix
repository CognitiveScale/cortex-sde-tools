nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "bokeh";
    version = "0.12.15";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "04v5mg7pjl8ivc4pq5adhjbd07rg48hkm5ky19hxq1q1nf1vi498";
    };

    propagatedBuildInputs = with self; [
        jinja2
        numpy
        packaging
        python-dateutil
        pyyaml
        six
        tornado
    ];

    checkPhase = ''
        ${self.python.interpreter} -m unittest discover -s bokeh/tests
    '';

    checkInputs = with self; [ mock pytest pillow selenium ];

    doCheck = true;

}
