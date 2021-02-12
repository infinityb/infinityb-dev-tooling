with (import <nixpkgs> {});
with (import ../default.nix);
let
  makeSquashImage = import ../lib/make-squashfs.nix;
  # kernel-name = config.boot.kernelPackages.kernel.name or "kernel";
  # 
  # modulesTree = config.system.modulesTree.override { name = kernel-name + "-modules"; };
  # firmware = config.hardware.firmware;

  # modulesClosure = pkgs.makeModulesClosure {
  #   rootModules = config.boot.initrd.availableKernelModules ++ config.boot.initrd.kernelModules;
  #   kernel = modulesTree;
  #  firmware = firmware;
  #  allowMissing = true;
  # };
  modulesClosure = pkgs.makeModulesClosure {
    rootModules = [
      "igb"       # Intel NIC
      "ixgbe"     # Intel NIC, 10GbE
      "squashfs"
    ];
    kernel = pkgs.linuxPackages.kernel;
    firmware = [];
  };

in rec {
  platformImage = makeSquashImage {
    configuration = {
      packages = [
        yspp.yscloud
        pkgs.linuxPackages.kernel

        pkgs.zfs
        pkgs.linuxPackages.zfs
      ];
    };
  };

  # HACK: add ${pkgs.linuxPackages.zfs} here if we need the zfs modules
  bootStageHelper = pkgs.writeText "stage1.proplist"
    ''
      MKDIR /lib
      LINK /lib/modules ${modulesClosure}/lib/modules
      LINK /lib/systemd ${pkgs.systemdMinimal}/lib/systemd
      MKDIR /usr
      MKDIR /usr/bin
      LINK /usr/bin/mount ${pkgs.busybox}/bin/mount
      LINK /usr/bin/udevadm ${pkgs.systemdMinimal}/bin/udevadm
      MKDIR /usr/sbin
      LINK /usr/sbin/netman ${yspp.yscloud}/bin/netman
      LINK /usr/sbin/sysctl ${pkgs.busybox}/bin/sysctl
    '';

  initrd = makeInitrd {
    name = "initrd-${pkgs.linuxPackages.kernel.name}";

    contents = [
      { object = "${yspp.yscloud}/bin/appliance-init";
        symlink = "/init";
      }
      { object = bootStageHelper;
        symlink = "/init.config";
      }
    ];
  };

  startScript = pkgs.writeText "run-vm"
    ''
    qemu-system-x86_64 \
        -m 1024 \
        -nographic -serial mon:stdio \
        -append 'console=ttyS0' \
        -netdev user,id=n1 -device virtio-net-pci,netdev=n1 \
        -kernel ${pkgs.linuxPackages.kernel}/bzImage \
        -initrd ${initrd}/initrd.gz
    '';
}
