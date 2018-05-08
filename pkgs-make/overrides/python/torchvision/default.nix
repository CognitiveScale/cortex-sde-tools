nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "torchvision";
    version = "0.2.0";
    name = "${pname}-${version}";

    src = super.fetchPypi {
        inherit pname version;
        format = "wheel";
        sha256 = "105wgi0mwv279l4ihd33x2w3prg6zq6733z3jhmm8dvw803xraml";
    };

    format = "wheel";

    propagatedBuildInputs = with self; [
        numpy
        pillow
        pytorch
        six
    ];

}
