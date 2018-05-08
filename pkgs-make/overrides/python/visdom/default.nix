pkgs: self: super:


super.buildPythonPackage rec {

    pname = "visdom";
    version = "0.1.7";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        sha256 = "1gd8s7qx6azi6aczj7sib4ajj31ns0ls8s9wrcchi2ibj4g2qwv2";
    };

    propagatedBuildInputs = with self; [
        numpy
        pillow
        pyzmq
        requests
        six
        torchfile
        tornado
    ];

    doCheck = false;  # broken, but also no tests to run

}
