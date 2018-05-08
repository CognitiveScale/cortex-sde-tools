nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "smart_open";
    version = "1.5.7";
    name = "${pname}-${version}";

    src = super.fetchPypi {
      inherit pname version;
      sha256 = "0y1c29pdxxgxkymr7g2n59siqqaq351zbx9vz8433dxvzy4qgd7p";
    };

    propagatedBuildInputs = with self; [
        boto
        boto3
        bz2file
        requests
        responses
    ];

    checkInputs = with self; [
        mock
        moto
    ];

    # DESIGN: depends on a very old version of moto (0.4.31)
    doCheck = false;

}
