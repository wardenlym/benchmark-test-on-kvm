# 查看命令行
virsh domxml-to-native qemu-argv --domain=node-00

LC_ALL=C PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin \
QEMU_AUDIO_DRV=spice \
/usr/libexec/qemu-kvm -name master-01 \
-machine pc-i440fx-rhel7.0.0,accel=kvm,usb=off,dump-guest-core=off \
-cpu Skylake-Server-IBRS,-md-clear,+spec-ctrl,+ssbd,+hypervisor,\
-arat -m 8192 -realtime mlock=off -smp 4,sockets=4,cores=1,threads=1 \
-uuid aa1800e2-9983-4ff1-84f0-c417d58518df \
-no-user-config \
-nodefaults \
-chardev socket,id=charmonitor,path=/var/lib/libvirt/qemu/domain--1-master-01/monitor.sock,server,nowait \
-mon chardev=charmonitor,id=monitor,mode=control \
-rtc base=utc,driftfix=slew \
-global kvm-pit.lost_tick_policy=delay -no-hpet -no-shutdown \
-global PIIX4_PM.disable_s3=1 \
-global PIIX4_PM.disable_s4=1 \
-boot strict=on \
-device ich9-usb-ehci1,id=usb,bus=pci.0,addr=0x5.0x7 \
-device ich9-usb-uhci1,masterbus=usb.0,firstport=0,bus=pci.0,multifunction=on,addr=0x5 \
-device ich9-usb-uhci2,masterbus=usb.0,firstport=2,bus=pci.0,addr=0x5.0x1 \
-device ich9-usb-uhci3,masterbus=usb.0,firstport=4,bus=pci.0,addr=0x5.0x2 \
-device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x6 \
-drive file=/data/vm/master-01.qcow2,format=qcow2,if=none,id=drive-ide0-0-0 \
-device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0,bootindex=1 \
-drive if=none,id=drive-ide0-0-1,readonly=on \
-device ide-cd,bus=ide.0,unit=1,drive=drive-ide0-0-1,id=ide0-0-1 -netdev tap,fd=25,id=hostnet0 \
-device rtl8139,netdev=hostnet0,id=net0,mac=52:54:00:6f:ad:6e,bus=pci.0,addr=0x3 -netdev tap,fd=28,id=hostnet1 \
-device virtio-net-pci,netdev=hostnet1,id=net1,mac=52:54:00:85:6b:e9,bus=pci.0,addr=0x8 -chardev pty,id=charserial0 \
-device isa-serial,chardev=charserial0,id=serial0 -chardev spicevmc,id=charchannel0,name=vdagent \
-device virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=com.redhat.spice.0 \
-spice port=5901,addr=127.0.0.1,disable-ticketing,image-compression=off,seamless-migration=on \
-vga qxl \
-global qxl-vga.ram_size=67108864 \
-global qxl-vga.vram_size=67108864 \
-global qxl-vga.vgamem_mb=16 \
-global qxl-vga.max_outputs=1 \
-device intel-hda,id=sound0,bus=pci.0,addr=0x4 \
-device hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 -chardev spicevmc,id=charredir0,name=usbredir \
-device usb-redir,chardev=charredir0,id=redir0,bus=usb.0,port=1 -chardev spicevmc,id=charredir1,name=usbredir \
-device usb-redir,chardev=charredir1,id=redir1,bus=usb.0,port=2 \
-device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x7 \
-msg timestamp=on
