self: super:

{
    cudnn_cudatoolkit9 = (import ./cudnn_cudatoolkit9.nix) self super;
    nccl_cudatoolkit9 = (import ./nccl_cudatoolkit9.nix) self super;
    igraph = (import ./igraph.nix) self super;
    rdkafka = (import ./rdkafka.nix) self super;
    jetbrains = super.jetbrains // {
        pycharm-community = (import ./pycharm-community.nix) self super;
    };

}
