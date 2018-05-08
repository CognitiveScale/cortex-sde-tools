{ writeShellScriptBin
, coreutils
, git
}:

let

    repo = "https://github.com/CognitiveScale/cortex-sde-tools.git";
    
in

writeShellScriptBin "cortex-sde-upgrade" ''
    set -u
    set -e
    ${coreutils}/bin/mkdir -p ~/.nix-defexpr
    if [ -e ~/.nix-defexpr/cortex ]
    then
        ${git}/bin/git -C ~/.nix-defexpr/cortex checkout master
        ${git}/bin/git -C ~/.nix-defexpr/cortex pull
    else
        ${git}/bin/git clone ${repo} ~/.nix-defexpr/cortex
    fi
    nix-env --install --attr cortex.sde
''
