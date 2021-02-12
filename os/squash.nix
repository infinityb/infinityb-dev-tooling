with (import <nixpkgs> {});
with (import ../default.nix);
let
  makeSquashImage = import ../lib/make-squashfs.nix;
in {
  all = makeSquashImage {
    configuration = {
      packages = [ yspp.inspircd yspp.yscloud ];
    };
  };
}
