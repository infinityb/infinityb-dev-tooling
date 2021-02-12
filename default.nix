with (import <nixpkgs> {});
let
  makeSquashImage = import ./lib/make-squashfs.nix;
  withSquashImage = package: package // {
    squashfsImage = makeSquashImage {
      configuration = { packages = [ package ]; };
    };
  };
in {
  ysop = {
    quasselDaemon = withSquashImage pkgs.quasselDaemon;
  };

  yspp = {
    inspircd = withSquashImage (callPackage ./inspircd {});
    yscloud = withSquashImage (callPackage ./yscloud {});
  };
}