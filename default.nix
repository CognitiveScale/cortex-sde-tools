let

    pkgs-make = (import ./pkgs-make) {};
    pkgs = pkgs-make (import ./pkgs);

in

{
    cortex-sde.tools-installer = pkgs.cortex-sde-tools-installer;
    cortex-sde.tools = with pkgs; {
        inherit
            cortex-sde-manage;
    };
    editors = with pkgs.nixpkgs; {
        inherit atom emacs;
        pycharm = pkgs.nixpkgs.jetbrains.pycharm-community;
        sublime = sublime3;
        vim = vimHugeX;
        vscode = vscode-with-extensions;
    };
    python = {
        conda = pkgs.nixpkgs.conda;
        #conda = pkgs.nixpkgs.python36Packages.conda;
    };
}
