nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "cortex-client";
    version = "5.0.10";
    name = "${pname}-${version}";

    src = nixpkgs.fetchurl {
        url = "https://cognitivescale.jfrog.io/cognitivescale/"
            + "cs-ml-internal-local/cortex/5.x/${name}.zip";
        sha256 = "155smqmmc7ksfinsc7jgj9nk1v5zf3cismhxkih8lwn213cd2h7n";
    };

    propagatedBuildInputs = with self; [
        flask
        requests
        requests-toolbelt
    ];

    checkInputs = with self; [
        mock
        mocket
        pytest
    ];

}
