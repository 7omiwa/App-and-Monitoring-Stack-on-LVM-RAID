#!/bin/bash

# Number of disks to create
NUM_DISKS=3
# Size of each disk
DISK_SIZE=2G
# Base name for disks
DISK_NAME="disk"

echo "Creating $NUM_DISKS sparse disk files of size $DISK_SIZE..."

for i in $(seq 1 $NUM_DISKS); do
    FILE_NAME="${DISK_NAME}${i}.img"
    echo "Creating $FILE_NAME..."
    # Use fallocate to create sparse file
    fallocate -l $DISK_SIZE $FILE_NAME
done

echo "All $NUM_DISKS disks created successfully."
