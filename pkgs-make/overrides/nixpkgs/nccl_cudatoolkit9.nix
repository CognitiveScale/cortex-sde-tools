self: super:

super.nccl_cudatoolkit9.overrideAttrs (old:
    let cudaVersion = "${old.passthru.cudatoolkit.majorVersion}";
    in rec {
        name = "cudatoolkit-${cudaVersion}-nccl-${version}";
        version = "2.1.15";
        src = super.fetchurl rec {
            name = "nccl_${version}-1+cuda${cudaVersion}_x86_64.txz";
            url = "https://cognitivescale.jfrog.io"
                + "/cognitivescale/cs-ml-internal-local"
                + "/vendor/nvidia/${name}";
            sha256 = "00fw8m653kxqngd6y181xwx4ywi59757mn5n25wn9zv2rhrm3hlh";
        };
    })
