#!/bin/bash

# Общие переменные
DISK_PATH="/var/lib/libvirt/images"
ISO_PATH="/var/lib/libvirt/iso"
RAM_MB=4096
VCPUS=2

# Создание qcow2-дисков
echo "Создаём образы дисков..."

qemu-img create -f qcow2 ${DISK_PATH}/win10-vm1.qcow2 40G
qemu-img create -f qcow2 ${DISK_PATH}/win10-vm2.qcow2 40G
qemu-img create -f qcow2 ${DISK_PATH}/ubuntu-vm.qcow2 20G

# ВМ 1: Windows 10
virt-install \
  --name win10-vm1 \
  --ram $RAM_MB \
  --vcpus $VCPUS \
  --os-type windows \
  --os-variant win10 \
  --hvm \
  --disk path=${DISK_PATH}/win10-vm1.qcow2,format=qcow2 \
  --cdrom ${ISO_PATH}/windows10.iso \
  --network network=default \
  --graphics spice \
  --video qxl \
  --boot useserial=on \
  --noautoconsole

# ВМ 2: Windows 10
virt-install \
  --name win10-vm2 \
  --ram $RAM_MB \
  --vcpus $VCPUS \
  --os-type windows \
  --os-variant win10 \
  --hvm \
  --disk path=${DISK_PATH}/win10-vm2.qcow2,format=qcow2 \
  --cdrom ${ISO_PATH}/windows10.iso \
  --network network=default \
  --graphics spice \
  --video qxl \
  --boot useserial=on \
  --noautoconsole

# ВМ 3: Ubuntu Server
virt-install \
  --name ubuntu-vm \
  --ram $RAM_MB \
  --vcpus $VCPUS \
  --os-type linux \
  --os-variant ubuntu22.04 \
  --hvm \
  --disk path=${DISK_PATH}/ubuntu-vm.qcow2,format=qcow2 \
  --cdrom ${ISO_PATH}/ubuntu-22.04.iso \
  --network network=default \
  --graphics none \
  --console pty,target_type=serial \
  --noautoconsole

echo "✅ Все виртуальные машины созданы. Завершено."