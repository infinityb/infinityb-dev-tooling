{
  pkgs,
  ...
}:
let
  yspp = (import ../default.nix).yspp;
  ysop = (import ../default.nix).ysop;
in
{
  # # # # # 
  #  Read http://blog.patapon.info/nixos-local-vm/
  # # # # #
  imports = [
    <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    # <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    #
    # # Provide an initial copy of the NixOS channel so that the user
    # # doesn't need to run "nix-channel --update" first.
    # <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  services.openssh.enable = true;
  security.hideProcessInformation = true;

  users.users."root".initialHashedPassword = "$6$rounds=15000$52bNzxGCXYcrR337$YwpLbwkk3XcCST2WDe1kaas70bBzL0KHPn1RYQAYFbtos9Jmi27DspwlFRE6BjSaA93ZCH6Wb6LaU6nzrp5VY/";
  users.users."root".hashedPassword = "$6$rounds=15000$52bNzxGCXYcrR337$YwpLbwkk3XcCST2WDe1kaas70bBzL0KHPn1RYQAYFbtos9Jmi27DspwlFRE6BjSaA93ZCH6Wb6LaU6nzrp5VY/";
  users.users."root".initialPassword = "$6$rounds=15000$52bNzxGCXYcrR337$YwpLbwkk3XcCST2WDe1kaas70bBzL0KHPn1RYQAYFbtos9Jmi27DspwlFRE6BjSaA93ZCH6Wb6LaU6nzrp5VY/";

  users.extraUsers.sell = {
    isNormalUser = true;
    home = "/home/sell";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILI+WddCXnpxDXQsP1FZpimg+Y8080lVPWhz9xfbEsMQ sell"
    ];
    initialHashedPassword = "$6$rounds=15000$52bNzxGCXYcrR337$YwpLbwkk3XcCST2WDe1kaas70bBzL0KHPn1RYQAYFbtos9Jmi27DspwlFRE6BjSaA93ZCH6Wb6LaU6nzrp5VY/";
    hashedPassword = "$6$rounds=15000$52bNzxGCXYcrR337$YwpLbwkk3XcCST2WDe1kaas70bBzL0KHPn1RYQAYFbtos9Jmi27DspwlFRE6BjSaA93ZCH6Wb6LaU6nzrp5VY/";
    initialPassword = "$6$rounds=15000$52bNzxGCXYcrR337$YwpLbwkk3XcCST2WDe1kaas70bBzL0KHPn1RYQAYFbtos9Jmi27DspwlFRE6BjSaA93ZCH6Wb6LaU6nzrp5VY/";
  };

  # environment.availableKernelModules = [ "squashfs" "iso9660" "uas" "overlay" ];
  environment.kernelModules = [ "loop" "overlay" "zfs" ];
  # environment.kernelPackages = pkgs.linuxPackages_latest ++ [ "bcachefs" "zfs" ];

  environment.systemPackages = (with pkgs; [
    wget
    vim
    rustup
    zfs
  ]) ++ (with yspp; [
    inspircd
    yscloud
  ]) ++ (with ysop; [
    quasselDaemon
  ]);
}