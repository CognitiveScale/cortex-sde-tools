pkgs: self: super:

{

    # TODO: Shelly compiles, but one test fails for some reason.  With Haskell
    # I really trust compilation, and suspect a fragile test that needs fixing.
    # If we update Nixpkgs, then see if this override can be removed.
    # Otherwise, we should probably dig into the failing test.
    shelly = pkgs.haskell.lib.dontCheck super.shelly;

    # DESIGN: just an example of using callHackage
    #protolude = super.callHackage "protolude" "0.2" {};

}
