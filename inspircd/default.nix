{
  system ? builtin.currentSystem,
  release-name ? "2020.04",
}:

let
  pkgsSrc = (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/29cc418d945856b0ae3d25e8d7d4f3d75d176618.tar.gz";
    sha256 = "1p64rapc25allphgk51lk7b5xvlbn2j70cpp023klf9ijahpdvja";
  });

  pkgsFn = import pkgsSrc;
  pkgs = pkgsFn { inherit system; };

  noCacheOptions = { allowSubstitutions = false; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  inspircd = callPackage ./build.nix { };

in self

