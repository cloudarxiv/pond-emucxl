#! /bin/bash

sudo /opt/qemu-8.2.2/bin/qemu-system-x86_64 -name emucxlVM \
-machine type=pc,accel=kvm,mem-merge=off -enable-kvm \
-cpu host -smp cpus=8 -m 16384M \
-object memory-backend-ram,size=8192M,policy=bind,host-nodes=0,id=ram-node0,prealloc=on,prealloc-threads=8 \
-numa node,nodeid=0,cpus=0-7,memdev=ram-node0 \
-object memory-backend-ram,size=8192M,policy=bind,host-nodes=1,id=ram-node1,prealloc=on,prealloc-threads=8 \
-numa node,nodeid=1,memdev=ram-node1 \
-device virtio-scsi-pci,id=scsi0 \
-device scsi-hd,drive=hd0 \
-drive file=~/images/emucxl.qcow2,if=none,aio=native,cache=none,format=qcow2,id=hd0 \
-net user,hostfwd=tcp::8080-:22 \
-net nic,model=virtio \
-device virtio-net,netdev=network0 \
-netdev tap,id=network0,ifname=tap0,script=no,downscript=no \
-drive file=~/images/ubuntu-22.04.4-live-server-amd64.iso,media=cdrom