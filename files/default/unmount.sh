#/bin/bash -e

DEVICE=$1
MOUNT_POINT=$2

if grep ^$DEVICE /etc/fstab; then
  grep -v ^$DEVICE /etc/fstab > /etc/fstab.new && mv /etc/fstab.new /etc/fstab
fi

if mount | grep ^$DEVICE >/dev/null; then
  umount $DEVICE
fi
