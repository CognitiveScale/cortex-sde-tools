# Managing Python/Nix dependencies

There's a [Google Sheet][SHEET] for manually figuring out which dependencies to
pin to.  The process is extremely manual for now, and involves creating a
Python 3.6 Conda environment to see what Conda resolves to.  We then can use
Nox to see what the latest Nixpkgs resolves to.  I then go to [PyPI][PYPI] to
see what the latest released package is.

In general, I try to stay at the latest version released to PyPI of ML,
statistics, and visualization packages.

For other dependencies (more engineering oriented) I make a decision based on

- constraints in PIP
- constraints in Conda
- availability in Conda
- convenience of what's already in Nix
- my interest on being at the latest version

[SHEET]: https://docs.google.com/spreadsheets/d/1c5wp2O5TpLt_HbtSSX0R0IFVQhm0I55CWxVIIttlIes
[PYPI]: https://pypi.python.org

