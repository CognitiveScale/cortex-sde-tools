nixpkgs: self: super:

super.buildPythonPackage rec {

    pname = "torchtext";
    version = "0.2.1";
    name = "${pname}-${version}";

    src = nixpkgs.fetchFromGitHub {
        owner = "pytorch";
        repo = "text";
        rev = "v${version}";
        sha256 = "1jl6ih2qhmfx213wc4lxd7gqzgrhn80i5a32g0liza9amqrdfh5a";
    };

    propagatedBuildInputs = with self; [
        pytorch
        requests
        tqdm
    ];

    doCheck = false;

}
