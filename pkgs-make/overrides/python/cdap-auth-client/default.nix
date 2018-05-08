nixpkgs: self: super:

super.buildPythonPackage
    rec {
        pname = "cdap-auth-client";
        version = "1.3.0.a.1";
        name = "${pname}-${version}";
        srcRoot = nixpkgs.fetchFromGitHub {
            owner = "caskdata";
            repo = "cdap-clients";
            rev = "v${version}";
            sha256 = "09k3lpcjpq1hzzkl200mcnid27pjkmrq5bcvz39bcq1yy71g96fl";
        };
        src = "${srcRoot}/cdap-authentication-clients/python";
        propagatedBuildInputs = [
            self.six
        ];
        doCheck = false;
    }
