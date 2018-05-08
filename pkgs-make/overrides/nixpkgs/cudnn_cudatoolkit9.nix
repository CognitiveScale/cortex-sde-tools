self: super:

super.cudnn_cudatoolkit9.overrideAttrs (old:
    let cudaVersion = "${old.passthru.cudatoolkit.majorVersion}";
    in rec {
        name = "cudatoolkit-${cudaVersion}-cudnn-${version}";
        version = "7.1";
        src = super.fetchurl rec {
            name = "cudnn-${cudaVersion}-linux-x64-v${version}.tgz";
            url = "https://cognitivescale.jfrog.io"
                + "/cognitivescale/cs-ml-internal-local"
                + "/vendor/nvidia/${name}";
            sha256 = "1v3r1766d2h1r4pll5xj28r79j9nyyymn4rfph4s1i8bf3nh0466";
        };
    })
