{ config, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [
  	wireguard
  	zfs
  ];
}
