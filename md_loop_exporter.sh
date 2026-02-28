#!/bin/bash
# =============================================================================
# Purpose: Export per-disk (loop or physical) state of a RAID device to
#          Prometheus via Node Exporter's textfile collector.
# Author: Generated for production use
# =============================================================================

# ----------------------------
# USER CONFIGURATION SECTION
# ----------------------------

# RAID device to monitor (default: md0)
RAID_DEVICE="md0"

# Node Exporter textfile collector directory (must exist and be writable)
TEXTFILE_DIR="/var/lib/node_exporter/textfile_collector"

# Optional: Specify disks manually. Leave empty to auto-detect from /proc/mdstat
# Example: DISKS=("loop17" "loop18" "loop19")
DISKS=()

# ----------------------------
# SCRIPT LOGIC
# ----------------------------

# Output file for Prometheus metrics
OUTPUT_FILE="$TEXTFILE_DIR/md_loop.prom"

# Create the file with metric help/type headers
echo "# HELP md_loop_active Loop disk active state (1=present, 0=missing)" > "$OUTPUT_FILE"
echo "# TYPE md_loop_active gauge" >> "$OUTPUT_FILE"

# If DISKS array is empty, auto-detect disks in the RAID device from /proc/mdstat
if [ ${#DISKS[@]} -eq 0 ]; then
    # awk parses md0 line, cut removes [index] suffix
    mapfile -t DISKS < <(awk -v dev="$RAID_DEVICE" '$1==dev ":" {for(i=5;i<=NF;i++) print $i}' /proc/mdstat | cut -d'[' -f1)
fi

# Loop through each disk and check if it exists using lsblk
for disk in "${DISKS[@]}"; do
    if lsblk -n | grep -qw "$disk"; then
        echo "md_loop_active{device=\"$RAID_DEVICE\",disk=\"$disk\"} 1" >> "$OUTPUT_FILE"
    else
        echo "md_loop_active{device=\"$RAID_DEVICE\",disk=\"$disk\"} 0" >> "$OUTPUT_FILE"
    fi
done

# Optional: Log runtime info (can be commented out if running via cron)
# echo "$(date '+%Y-%m-%d %H:%M:%S') Exported loop disk metrics for $RAID_DEVICE"
