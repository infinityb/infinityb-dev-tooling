{ stdenv, pkgs, rustPlatform }:
rustPlatform.buildRustPackage rec {
  name = "yscloud-${version}";
  version = "0.2.0";
  src = ./yscloud-vendor.tar.gz;
  nativeBuildInputs = with pkgs; [ pkgconfig openssl protobuf rustfmt git libseccomp ];
  buildInputs = with pkgs; [ pkgconfig openssl protobuf rustfmt git libseccomp ];

  checkPhase = "";
  cargoSha256 = "0000000000000000000000000000000000000000000000000000";
  cargoVendorDir = "vendor";

  # for pros and tonic
  PROTOC="${pkgs.protobuf}/bin/protoc";

  meta = with stdenv.lib; {
    description = "yscloud runtime environment";
    license = licenses.unfree;
    maintainers = [ "Stacey Ell <software@e.staceyell.com>" ];
    platforms = platforms.all;
  };
}
