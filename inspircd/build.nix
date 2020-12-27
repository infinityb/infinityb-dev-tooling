with (import <nixpkgs> {});
derivation {
  name = "inspircd";
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];
  buildInputs = [ gnutar gzip gnumake gcc binutils-unwrapped coreutils gawk gnused gnugrep perl openssl openssl.dev which pkgconfig findutils bash ];
  src = ./inspircd-3.8.1.tar.gz;
  system = builtins.currentSystem;
}

