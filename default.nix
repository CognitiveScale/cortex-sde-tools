let

    pkgs-make = (import ./pkgs-make) {};
    pkgs = pkgs-make (import ./pkgs);

in

{
    sde = with pkgs; {
        inherit
            cortex-sde-upgrade
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
        conda = pkgs.nixpkgs.python36Packages.conda;
    };
}
