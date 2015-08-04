#/bin/bash -e

DEVICE=$1
FILE_SYSTEM=$2
MOUNT_POINT=$3

if [ "$(file -sL $DEVICE)" == "$DEVICE: data" ]; then
  mkfs -t $FILE_SYSTEM $DEVICE
fi

if ! grep ^$DEVICE /etc/fstab; then
  cat >> /etc/fstab <<< "$DEVICE $MOUNT_POINT $FILE_SYSTEM defaults,nofail 0 2"
fi

mount -a
