nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "cortex-client";
    versionMaj = "1.1.0";
    versionMin = "31";
    versionHash = "g3f8f9fb";
    versionOld = "${versionMaj}+${versionMin}.${versionHash}";
    versionPat = "${versionMaj}.${versionMin}.${versionHash}";
    versionNew = "${versionMaj}.${versionMin}";
    name = "${pname}-${versionNew}";

    src = nixpkgs.fetchurl {
        url = "https://cognitivescale.jfrog.io/cognitivescale/"
            + "cognitivescale_local/${pname}/"
            + versionOld
            + "/${pname}-"
            + versionOld
            + ".zip";
        sha256 = "1a4pqmgqr7mlaa9vqdzvmfk755xdqhgb94sfcr79fr5c4yrfs88f";
    };

    propagatedBuildInputs = [
        self.cdap-auth-client
        self.avro
        self.future
        self.kafka-python
        self.pyzmq
        self.requests
        self.six
    ];

    buildInputs = [
        self.pytestrunner
    ];

    doCheck = false;

    preConfigure = ''
        grep -rl "${versionMaj}" "$PWD" | \
            while read -r file
            do sed -i -e 's/${versionPat}/${versionNew}/g' "$file"
            done
    '';

}
