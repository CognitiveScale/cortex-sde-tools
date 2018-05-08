{ writeShellScriptBin
, coreutils
, git
}:

let

    repo = "https://github.com/CognitiveScale/cortex-sde-tools.git";
    
in

writeShellScriptBin "cortex-sde-tools-install" ''
    ${coreutils}/bin/mkdir -p ~/.nix-defexpr
    ${git}/bin/git ${repo} ~/.nix-defexpr/cortex-sde
    nix-env --install --attr cortex-sde.core
''
