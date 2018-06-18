{ buildPythonPackage
, docker
, pyjq
, requests
}:

buildPythonPackage {
    name = "cortex-sde-ship";
    src = ./.;
    propagatedBuildInputs = [
        docker
        pyjq
        requests
    ];
}
