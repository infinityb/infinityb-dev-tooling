{ pkgs, fetchurl }:
derivation {
  name = "inspircd";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./builder.sh ];
  buildInputs = with pkgs; [ gnutar gzip gnumake gcc binutils-unwrapped coreutils gawk gnused gnugrep perl openssl openssl.dev which pkgconfig findutils bash ];
  src = fetchurl {
    sha256 = "0jxlh7ip5pd6fp8axwy4b35gn3v908726l5nfhgjwf4vyd1cls10";
    url = "https://yyc.mediarepo.yshi.org/sources/tarballs/inspircd-3.8.1.tar.gz";
  };
  system = builtins.currentSystem;
}