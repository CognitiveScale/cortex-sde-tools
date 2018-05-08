self: super:

super.stdenv.mkDerivation {
    name = "rdkafka";
    version = "0.9.3";
    src = super.fetchFromGitHub {
        owner = "edenhill";
        repo = "librdkafka";
        # $ git describe v0.11.3 --tags --long
        # v0.11.3-0-gb581d0d
        rev = "b581d0d9df282847f76e8b9e87337161959d39c9";
        sha256 = "17ghq0kzk2fdpxhr40xgg3s0p0n0gkvd0d85c6jsww3mj8v5xd14";
    };
    buildInputs = [ super.zlib super.python ];
    NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";
    postPatch = ''patchShebangs .'';
}
