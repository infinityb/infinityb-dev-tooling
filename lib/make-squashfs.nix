{
  pkgs ? import <nixpkgs> { system = "x86_64-linux"; },
  configuration,
}:
  {
    squashfsStore = pkgs.callPackage <nixpkgs/nixos/lib/make-squashfs.nix> {
      storeContents = configuration.packages;
    };
  }