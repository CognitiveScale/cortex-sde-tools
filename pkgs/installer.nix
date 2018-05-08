{ writeShellScriptBin
, coreutils
, git
}:

let

    repo = "https://github.com/CognitiveScale/cortex-sde-tools.git";
    
in

writeShellScriptBin "cortex-sde-tools-install" ''
    ${coreutils}/bin/mkdir -p ~/.nix-defexpr
    if [ -e ~/.nix-defexpr/cortex-sde ]
    then ${git}/bin/git clone ${repo} ~/.nix-defexpr/cortex-sde
    else ${git}/bin/git clone ${repo} ~/.nix-defexpr/cortex-sde
    fi
    nix-env --install --attr cortex-sde.tools
''
