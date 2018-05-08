nixpkgs: self: super:

let cudatoolkit = nixpkgs.cudatoolkit9;
in

super.buildPythonPackage rec {

    version = "0.3.1";
    pname = "pytorch";
    name = "${pname}-${version}";

    src = nixpkgs.fetchFromGitHub {
        owner  = "pytorch";
        repo   = "pytorch";
        rev    = "v${version}";
        sha256 = "1k8fr97v5pf7rni5cr2pi21ixc3pdj3h3lkz28njbjbgkndh7mr3";
        fetchSubmodules = true;
    };

    nativeBuildInputs = [
        cudatoolkit.cc
        nixpkgs.cmake
        nixpkgs.git
        nixpkgs.utillinux
        nixpkgs.which
    ];

    buildInputs = [
        cudatoolkit.lib
        nixpkgs.cudnn_cudatoolkit9
        nixpkgs.nccl_cudatoolkit9
        self.numpy.blas
    ];

    propagatedBuildInputs = with self; [
        cffi
        numpy
        pyyaml
    ];

    preConfigure = ''
        export NO_CUDA=0
        export CUDA_LIB="${cudatoolkit.lib}/lib"
        export CUDNN_LIB_DIR="${nixpkgs.cudnn_cudatoolkit9}/lib"
        export CUDNN_INCLUDE_DIR="${nixpkgs.cudnn_cudatoolkit9}/include"
    '';

    checkPhase = '' ${nixpkgs.stdenv.shell} test/run_test.sh '';

    doCheck = false;

}
